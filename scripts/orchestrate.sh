#!/bin/bash
# ==============================================================================
# orchestrate.sh - Parallel agent orchestrator
#
# Architecture:
#   - Spawner: Finds open tasks, launches worker agents
#   - Worker: Implements task, creates PR, adds pr:<id> label
#   - Merger: Finds in_progress tasks with pr: labels, merges PRs, cleans up
#
# State Machine:
#   open → in_progress → in_progress+pr:N label → closed
#   (+ blocked for tasks with unmet dependencies)
#
# Detection:
#   - "working": in_progress WITHOUT pr: label
#   - "pr_ready": in_progress WITH pr: label
# ==============================================================================
set -euo pipefail

WORKTREE_BASE="../worktrees"
MAX_AGENTS=4
EPIC_FILTER=""
DRY_RUN=false
WATCH_MODE=false

STATE_DIR=".beads/orchestrator"
LOGS_DIR="$STATE_DIR/logs"
PID_FILE="$STATE_DIR/pids.json"

# ============ ARGUMENT PARSING ============
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [COMMAND]

Commands:
  (none)              Run combined spawner + merger loop
  spawner             Run spawner only (launch workers)
  merger              Run merger only (merge PRs)
  status              Show agent status table
  logs                List all agent logs
  log TASK_ID         Show full log for a task
  tail TASK_ID [N]    Follow log output

Options:
  -e, --epic EPIC_ID    Only process tasks under this epic
  -m, --max-agents N    Maximum parallel agents (default: 4)
  -w, --watch           Keep running in loop (for merger)
  -d, --dry-run         Show what would happen without executing
  -h, --help            Show this help
EOF
    exit 0
}

COMMAND=""
COMMAND_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--epic) EPIC_FILTER="$2"; shift 2 ;;
        -m|--max-agents) MAX_AGENTS="$2"; shift 2 ;;
        -w|--watch) WATCH_MODE=true; shift ;;
        -d|--dry-run) DRY_RUN=true; shift ;;
        -h|--help) usage ;;
        spawner|merger|status|logs|log|tail)
            COMMAND="$1"
            shift
            COMMAND_ARGS=("$@")
            break
            ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

log() { echo "[$(date '+%H:%M:%S')] $*"; }
dry() { $DRY_RUN && echo "[DRY-RUN] $*" && return 0 || return 1; }

# ============ STATE MANAGEMENT ============
init_state() {
    mkdir -p "$STATE_DIR"
    mkdir -p "$LOGS_DIR"
    [ -f "$PID_FILE" ] || echo '{}' > "$PID_FILE"
}

get_pid() {
    local task_id=$1
    jq -r --arg id "$task_id" '.[$id] // empty' "$PID_FILE" 2>/dev/null
}

set_pid() {
    local task_id=$1
    local pid=$2
    local tmp=$(mktemp)
    jq --arg id "$task_id" --arg p "$pid" '.[$id] = $p' "$PID_FILE" > "$tmp"
    mv "$tmp" "$PID_FILE"
}

remove_pid() {
    local task_id=$1
    local tmp=$(mktemp)
    jq --arg id "$task_id" 'del(.[$id])' "$PID_FILE" > "$tmp"
    mv "$tmp" "$PID_FILE"
}

# ============ QUERIES ============
get_open_tasks() {
    local tasks blocked_ids
    if [ -n "$EPIC_FILTER" ]; then
        # Get open tasks under epic, then filter out blocked ones
        tasks=$(bd list --status open --parent "$EPIC_FILTER" --json 2>/dev/null || echo "[]")
        blocked_ids=$(bd blocked --json 2>/dev/null | jq -r '.[].id' || echo "")
        if [ -n "$blocked_ids" ]; then
            echo "$tasks" | jq --argjson blocked "$(echo "$blocked_ids" | jq -R -s 'split("\n") | map(select(length > 0))')" \
                '[.[] | select(.id as $id | $blocked | index($id) | not)]'
        else
            echo "$tasks"
        fi
    else
        bd ready --json 2>/dev/null || echo "[]"
    fi
}

get_in_progress_tasks() {
    # Tasks in_progress WITHOUT pr:* label (still working, no PR yet)
    local tasks
    if [ -n "$EPIC_FILTER" ]; then
        tasks=$(bd list --status in_progress --parent "$EPIC_FILTER" --json 2>/dev/null || echo "[]")
    else
        tasks=$(bd list --status in_progress --json 2>/dev/null || echo "[]")
    fi
    # Filter out tasks that have pr: labels
    echo "$tasks" | jq '[.[] | select(((.labels // []) | any(startswith("pr:"))) | not)]'
}

get_pr_created_tasks() {
    # Tasks in_progress WITH pr:* label (PR created, waiting for merge)
    local tasks
    if [ -n "$EPIC_FILTER" ]; then
        tasks=$(bd list --status in_progress --parent "$EPIC_FILTER" --json 2>/dev/null || echo "[]")
    else
        tasks=$(bd list --status in_progress --json 2>/dev/null || echo "[]")
    fi
    # Filter to only tasks that have pr: labels
    echo "$tasks" | jq '[.[] | select((.labels // []) | any(startswith("pr:")))]'
}

get_pr_label() {
    local task_id=$1
    bd show "$task_id" --json 2>/dev/null | jq -r '.[0].labels[]? | select(startswith("pr:")) | sub("pr:"; "")' | head -1
}

# ============ SPAWNER ============
spawn_worker() {
    local task_id=$1
    local subject=$2
    local worktree="${WORKTREE_BASE}/${task_id}"
    local branch="agent/${task_id}"

    log "Spawning: $task_id - $subject"

    if dry "Would spawn worker for $task_id"; then
        return 0
    fi

    # Create worktree
    if [ ! -d "$worktree" ]; then
        git worktree add "$worktree" -b "$branch" 2>/dev/null || \
        git worktree add "$worktree" "$branch" 2>/dev/null || {
            log "ERROR: Failed to create worktree for $task_id"
            return 1
        }
    fi

    # Update status
    bd update "$task_id" --status in_progress 2>/dev/null || true

    # Set up logging
    local log_dir="$(pwd)/${LOGS_DIR}/${task_id}"
    mkdir -p "$log_dir"
    local log_file="${log_dir}/agent.log"

    # Initialize log
    {
        echo "=== Worker started at $(date -Iseconds) ==="
        echo "Task: $task_id - $subject"
        echo "Worktree: $worktree"
        echo "---"
    } > "$log_file"

    # Build prompt
    local prompt
    if [ -f "$worktree/.claude/agents/worker.md" ]; then
        prompt=$(sed "s/\$TASK_ID/$task_id/g" "$worktree/.claude/agents/worker.md")
    else
        prompt="Execute beads task $task_id. Run 'bd show $task_id' for details. Create PR when done and run: bd update $task_id --status pr_created"
    fi

    # Launch worker (script provides PTY for real-time logs)
    (
        cd "$worktree"
        if [[ "$(uname)" == "Darwin" ]]; then
            script -q "$log_file" claude --dangerously-skip-permissions "$prompt" >/dev/null 2>&1
        else
            script -q -c "claude --dangerously-skip-permissions \"$prompt\"" "$log_file" >/dev/null 2>&1
        fi
        echo "---" >> "$log_file"
        echo "=== Worker finished at $(date -Iseconds) ===" >> "$log_file"
    ) </dev/null &

    local pid=$!
    set_pid "$task_id" "$pid"
    log "Started worker PID $pid for $task_id"
}

run_spawner() {
    log "Running spawner (max $MAX_AGENTS agents)"

    # Count current in_progress tasks
    local in_progress
    in_progress=$(get_in_progress_tasks | jq 'length')

    if [ "$in_progress" -ge "$MAX_AGENTS" ]; then
        log "At capacity: $in_progress/$MAX_AGENTS agents running"
        return 0
    fi

    local slots=$((MAX_AGENTS - in_progress))
    log "Available slots: $slots"

    # Get open tasks and spawn workers
    get_open_tasks | jq -c '.[]' 2>/dev/null | head -n "$slots" | while read -r task; do
        [ -z "$task" ] || [ "$task" = "null" ] && continue

        local task_id subject
        task_id=$(echo "$task" | jq -r '.id')
        subject=$(echo "$task" | jq -r '.title // .subject')

        spawn_worker "$task_id" "$subject"
    done
}

# ============ MERGER ============
kill_worker() {
    local task_id=$1
    local pid
    pid=$(get_pid "$task_id")

    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        log "Killing worker PID $pid for $task_id"
        kill "$pid" 2>/dev/null || true
        # Kill child processes too
        pkill -P "$pid" 2>/dev/null || true
    fi

    remove_pid "$task_id"
}

cleanup_worktree() {
    local task_id=$1
    local worktree="${WORKTREE_BASE}/${task_id}"
    local branch="agent/${task_id}"

    if [ -d "$worktree" ]; then
        log "Removing worktree: $worktree"
        git worktree remove "$worktree" --force 2>/dev/null || true
    fi

    # Delete local branch
    git branch -D "$branch" 2>/dev/null || true

    # Delete remote branch (in case --delete-branch didn't work or PR was already merged)
    git push origin --delete "$branch" 2>/dev/null || true
}

merge_pr() {
    local task_id=$1
    local pr_num=$2

    log "Checking PR #$pr_num for $task_id"

    # Check PR state
    local pr_state pr_mergeable
    pr_state=$(gh pr view "$pr_num" --json state --jq '.state' 2>/dev/null || echo "UNKNOWN")

    # If already merged, return success (cleanup should happen)
    if [ "$pr_state" = "MERGED" ]; then
        log "PR #$pr_num already merged"
        return 0
    fi

    # If closed (not merged), something went wrong
    if [ "$pr_state" = "CLOSED" ]; then
        log "WARNING: PR #$pr_num was closed without merging"
        return 1
    fi

    # Check if PR is mergeable
    pr_mergeable=$(gh pr view "$pr_num" --json mergeable --jq '.mergeable' 2>/dev/null || echo "UNKNOWN")

    if [ "$pr_mergeable" != "MERGEABLE" ]; then
        log "PR #$pr_num not ready to merge (state=$pr_state, mergeable=$pr_mergeable)"
        return 1
    fi

    if dry "Would merge PR #$pr_num"; then
        return 0
    fi

    log "Merging PR #$pr_num"
    if gh pr merge "$pr_num" --squash --delete-branch 2>/dev/null; then
        log "Successfully merged PR #$pr_num"
        return 0
    else
        log "Failed to merge PR #$pr_num"
        return 1
    fi
}

check_and_close_epic() {
    # Check if all tasks under the epic are closed, and if so, close the epic
    [ -z "$EPIC_FILTER" ] && return 0

    local open_tasks
    open_tasks=$(bd list --parent "$EPIC_FILTER" --json 2>/dev/null | jq '[.[] | select(.status != "closed")] | length')

    if [ "$open_tasks" -eq 0 ]; then
        if ! dry "Would close epic $EPIC_FILTER"; then
            bd close "$EPIC_FILTER" --reason "All tasks completed" 2>/dev/null || true
            log "Closed epic $EPIC_FILTER (all tasks completed)"
        fi
    fi
}

run_merger() {
    log "Running merger"

    local tasks
    tasks=$(get_pr_created_tasks)
    local count
    count=$(echo "$tasks" | jq 'length')

    if [ "$count" -eq 0 ]; then
        log "No tasks with status=pr_created"
        # Still check if epic should be closed
        check_and_close_epic
        return 0
    fi

    log "Found $count task(s) with PRs to merge"

    echo "$tasks" | jq -c '.[]' 2>/dev/null | while read -r task; do
        [ -z "$task" ] || [ "$task" = "null" ] && continue

        local task_id
        task_id=$(echo "$task" | jq -r '.id')

        # Get PR number from label
        local pr_num
        pr_num=$(get_pr_label "$task_id")

        if [ -z "$pr_num" ]; then
            log "WARNING: Task $task_id has status=pr_created but no pr: label"
            continue
        fi

        # Try to merge
        if merge_pr "$task_id" "$pr_num"; then
            # Kill worker
            kill_worker "$task_id"

            # Cleanup worktree
            cleanup_worktree "$task_id"

            # Close task
            if ! dry "Would close task $task_id"; then
                bd close "$task_id" 2>/dev/null || true
                log "Closed task $task_id"
            fi
        fi
    done

    # Check if epic should be closed after processing all tasks
    check_and_close_epic
}

# ============ STATUS & LOGS ============
show_status() {
    echo "=== Task Status ==="
    echo ""
    printf "%-12s  %-14s  %-8s  %s\n" "TASK" "STATUS" "PID" "PR"
    printf "%-12s  %-14s  %-8s  %s\n" "----" "------" "---" "--"

    # Get all relevant tasks
    {
        get_in_progress_tasks
        get_pr_created_tasks
    } | jq -s 'add // []' | jq -c '.[]' 2>/dev/null | while read -r task; do
        [ -z "$task" ] || [ "$task" = "null" ] && continue

        local task_id status pr_label pid pid_status
        task_id=$(echo "$task" | jq -r '.id')
        status=$(echo "$task" | jq -r '.status')

        pr_label=$(get_pr_label "$task_id")
        [ -n "$pr_label" ] && pr_label="PR #$pr_label"

        pid=$(get_pid "$task_id")
        if [ -n "$pid" ]; then
            if kill -0 "$pid" 2>/dev/null; then
                pid_status="$pid (alive)"
            else
                pid_status="$pid (dead)"
            fi
        else
            pid_status="-"
        fi

        printf "%-12s  %-14s  %-8s  %s\n" "$task_id" "$status" "$pid_status" "$pr_label"
    done

    echo ""

    # Show open PRs
    local pr_count
    pr_count=$(gh pr list --json number --jq 'length' 2>/dev/null || echo "0")
    if [ "$pr_count" -gt 0 ]; then
        echo "=== Open PRs ==="
        gh pr list --json number,title,headRefName \
            --jq '.[] | select(.headRefName | startswith("agent/")) | "#\(.number): \(.title)"' 2>/dev/null
    fi
}

show_logs() {
    echo "=== Agent Logs ==="
    if [ ! -d "$LOGS_DIR" ] || [ -z "$(ls -A "$LOGS_DIR" 2>/dev/null)" ]; then
        echo "(no logs)"
        return 0
    fi

    printf "%-12s  %s\n" "TASK" "SIZE"
    printf "%-12s  %s\n" "----" "----"

    for log_dir in "$LOGS_DIR"/*/; do
        [ -d "$log_dir" ] || continue
        local task_id log_size
        task_id=$(basename "$log_dir")
        log_size=$(wc -c < "${log_dir}/agent.log" 2>/dev/null | tr -d ' ' || echo "0")

        if [ "$log_size" -gt 1048576 ]; then
            log_size="$((log_size / 1048576))MB"
        elif [ "$log_size" -gt 1024 ]; then
            log_size="$((log_size / 1024))KB"
        else
            log_size="${log_size}B"
        fi

        printf "%-12s  %s\n" "$task_id" "$log_size"
    done
}

show_log() {
    local task_id=$1
    local log_file="${LOGS_DIR}/${task_id}/agent.log"

    if [ ! -f "$log_file" ]; then
        echo "No log found for $task_id"
        ls -1 "$LOGS_DIR" 2>/dev/null || echo "(no logs)"
        exit 1
    fi

    cat "$log_file"
}

tail_log() {
    local task_id=$1
    local lines=${2:-50}
    local log_file="${LOGS_DIR}/${task_id}/agent.log"

    if [ ! -f "$log_file" ]; then
        echo "No log found for $task_id"
        exit 1
    fi

    tail -f -n "$lines" "$log_file"
}

# ============ MAIN ============
handle_command() {
    case "$COMMAND" in
        spawner)
            init_state
            if $WATCH_MODE; then
                while true; do
                    run_spawner
                    sleep 30
                done
            else
                run_spawner
            fi
            exit 0
            ;;
        merger)
            init_state
            if $WATCH_MODE; then
                while true; do
                    run_merger
                    sleep 30
                done
            else
                run_merger
            fi
            exit 0
            ;;
        status)
            init_state
            show_status
            exit 0
            ;;
        logs)
            init_state
            show_logs
            exit 0
            ;;
        log)
            init_state
            [ ${#COMMAND_ARGS[@]} -lt 1 ] && { echo "Usage: $0 log TASK_ID"; exit 1; }
            show_log "${COMMAND_ARGS[0]}"
            exit 0
            ;;
        tail)
            init_state
            [ ${#COMMAND_ARGS[@]} -lt 1 ] && { echo "Usage: $0 tail TASK_ID [LINES]"; exit 1; }
            tail_log "${COMMAND_ARGS[0]}" "${COMMAND_ARGS[1]:-50}"
            exit 0
            ;;
    esac
}

[ -n "$COMMAND" ] && handle_command

# Default: run combined spawner + merger loop
main() {
    init_state

    [ -n "$EPIC_FILTER" ] && log "Filtering to epic: $EPIC_FILTER"
    $DRY_RUN && log "DRY RUN MODE"
    log "Starting orchestrator (max $MAX_AGENTS agents)"

    while true; do
        # Run spawner
        run_spawner

        # Run merger
        run_merger

        # Status summary
        local in_progress pr_created open_count
        in_progress=$(get_in_progress_tasks | jq 'length')
        pr_created=$(get_pr_created_tasks | jq 'length')
        open_count=$(get_open_tasks | jq 'length')

        log "Status: $in_progress working, $pr_created pending merge, $open_count ready"

        # Done?
        if [ "$in_progress" -eq 0 ] && [ "$pr_created" -eq 0 ] && [ "$open_count" -eq 0 ]; then
            log "All tasks complete!"
            break
        fi

        $DRY_RUN && { log "Dry run complete"; break; }

        sleep 30
    done
}

main
