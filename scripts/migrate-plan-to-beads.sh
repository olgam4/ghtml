#!/bin/bash
# ==============================================================================
# migrate-plan-to-beads.sh - Migrate .claude/plan/ epics to Beads
#
# Usage: ./scripts/migrate-plan-to-beads.sh [OPTIONS]
#
# Options:
#   -d, --dry-run       Show what would be migrated without making changes
#   -e, --epic NAME     Only migrate specific epic (folder name)
#   -h, --help          Show this help
#
# Description:
#   Scans .claude/plan/ directory for incomplete tasks and creates corresponding
#   Beads issues with links back to the spec files. Completed tasks are skipped.
#   Migration is idempotent - safe to run multiple times.
# ==============================================================================
set -euo pipefail

PLAN_DIR=".claude/plan"
DRY_RUN=false
EPIC_FILTER=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dry-run) DRY_RUN=true; shift ;;
        -e|--epic) EPIC_FILTER="$2"; shift 2 ;;
        -h|--help)
            head -20 "$0" | grep -E "^#" | sed 's/^# //'
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

log() { echo "[MIGRATE] $*"; }
dry() { $DRY_RUN && echo "[DRY-RUN] $*" && return 0 || return 1; }

# Stats
epics_created=0
tasks_created=0
tasks_skipped=0
tasks_existing=0

# Parse task status from README.md
# Returns: pending, in_progress, complete, blocked
parse_task_status() {
    local readme="$1"
    local task_num="$2"

    if [ ! -f "$readme" ]; then
        echo "pending"
        return
    fi

    # Look for status in table: | 001 | Task Name | [x] Complete |
    local line=$(grep -E "^\| *0*${task_num} *\|" "$readme" 2>/dev/null || echo "")

    if echo "$line" | grep -q "\[x\]"; then
        echo "complete"
    elif echo "$line" | grep -q "\[~\]"; then
        echo "in_progress"
    elif echo "$line" | grep -q "\[!\]"; then
        echo "blocked"
    else
        echo "pending"
    fi
}

# Get task subject from file header
parse_task_subject() {
    local task_file="$1"

    # Extract from "# Task NNN: Subject" or "# Task: Subject" header
    head -5 "$task_file" | grep -E "^# Task" | sed 's/^# Task[^:]*: *//' | head -1 || \
        basename "$task_file" .md | sed 's/^[0-9]*_//' | tr '_' ' '
}

# Get epic title from PLAN.md
parse_epic_title() {
    local plan_file="$1"
    head -5 "$plan_file" | grep -E "^# (Epic:|Plan:)" | sed 's/^# [^:]*: *//' || \
        basename "$(dirname "$plan_file")"
}

# Check if issue already exists in beads by title
issue_exists() {
    local title="$1"
    bd list --json 2>/dev/null | jq -e --arg t "$title" '.[] | select(.title == $t)' > /dev/null 2>&1
}

# Migrate a single epic
migrate_epic() {
    local epic_dir="$1"
    local epic_name=$(basename "$epic_dir")

    log "Processing epic: $epic_name"

    # Skip template and complete
    if [ "$epic_name" = "_template" ] || [ "$epic_name" = "_complete" ]; then
        log "  Skipping: $epic_name"
        return
    fi

    # Check for PLAN.md
    local plan_file="${epic_dir}/PLAN.md"
    if [ ! -f "$plan_file" ]; then
        log "  Warning: No PLAN.md found, skipping"
        return
    fi

    # Extract epic title
    local epic_title=$(parse_epic_title "$plan_file")
    local epic_id=""

    # Check if epic already exists
    if issue_exists "Epic: $epic_title"; then
        log "  Epic already exists: Epic: $epic_title"
        # Get existing epic ID
        epic_id=$(bd list --json 2>/dev/null | jq -r --arg t "Epic: $epic_title" '.[] | select(.title == $t) | .id' | head -1)
    else
        if dry "Would create epic: Epic: $epic_title"; then
            ((epics_created++)) || true
        else
            log "  Creating epic: Epic: $epic_title"
            epic_id=$(bd create "Epic: $epic_title" -p 0 --label epic --json 2>/dev/null | jq -r '.id')
            ((epics_created++)) || true
        fi
    fi

    # Process tasks
    local tasks_dir="${epic_dir}/tasks"
    local readme="${tasks_dir}/README.md"

    if [ ! -d "$tasks_dir" ]; then
        log "  No tasks directory, skipping"
        return
    fi

    # Process each task file
    for task_file in "$tasks_dir"/[0-9][0-9][0-9]*.md; do
        [ -f "$task_file" ] || continue

        local task_basename=$(basename "$task_file")
        local task_num=${task_basename:0:3}
        # Remove leading zeros for status lookup
        local task_num_clean=$(echo "$task_num" | sed 's/^0*//')
        [ -z "$task_num_clean" ] && task_num_clean="0"

        local task_subject=$(parse_task_subject "$task_file")
        local task_status=$(parse_task_status "$readme" "$task_num_clean")

        # Skip completed tasks
        if [ "$task_status" = "complete" ]; then
            log "    [$task_num] $task_subject - SKIP (complete)"
            ((tasks_skipped++)) || true
            continue
        fi

        # Check if task already exists
        if issue_exists "$task_subject"; then
            log "    [$task_num] $task_subject - EXISTS"
            ((tasks_existing++)) || true
            continue
        fi

        # Determine priority based on status
        local priority=2
        [ "$task_status" = "in_progress" ] && priority=1
        [ "$task_status" = "blocked" ] && priority=3

        if dry "Would create task: [$task_num] $task_subject (status: $task_status, parent: $epic_id)"; then
            ((tasks_created++)) || true
        else
            log "    [$task_num] Creating: $task_subject (parent: $epic_id)"
            # Create task with parent link to epic
            if [ -n "$epic_id" ]; then
                bd create "$task_subject" -p "$priority" --label task --parent "$epic_id" 2>/dev/null || true
            else
                bd create "$task_subject" -p "$priority" --label task 2>/dev/null || true
            fi
            ((tasks_created++)) || true

            # Set in_progress if needed
            if [ "$task_status" = "in_progress" ]; then
                local task_id=$(bd list --json 2>/dev/null | jq -r --arg t "$task_subject" '.[] | select(.title == $t) | .id' | head -1)
                [ -n "$task_id" ] && bd update "$task_id" --status in_progress 2>/dev/null || true
            fi
        fi
    done
}

# Generate report
generate_report() {
    echo ""
    echo "=============================================="
    echo "Migration Report"
    echo "=============================================="
    echo ""
    echo "Epics created:    $epics_created"
    echo "Tasks created:    $tasks_created"
    echo "Tasks skipped:    $tasks_skipped (already complete)"
    echo "Tasks existing:   $tasks_existing (already in beads)"
    echo ""
    echo "=============================================="
}

# Main
main() {
    log "Starting migration from .claude/plan/ to Beads"

    # Verify beads is initialized
    if ! bd list > /dev/null 2>&1; then
        echo "Error: Beads not initialized. Run 'bd init' first."
        exit 1
    fi

    $DRY_RUN && log "DRY RUN MODE - no changes will be made"

    # Process epics
    for epic_dir in "$PLAN_DIR"/*/; do
        [ -d "$epic_dir" ] || continue

        local epic_name=$(basename "$epic_dir")

        # Filter if specified
        if [ -n "$EPIC_FILTER" ] && [ "$epic_name" != "$EPIC_FILTER" ]; then
            continue
        fi

        migrate_epic "$epic_dir"
    done

    generate_report

    log "Migration complete!"
}

main "$@"
