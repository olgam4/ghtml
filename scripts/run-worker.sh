#!/bin/bash
# ==============================================================================
# run-worker.sh - Manual worker agent invocation
#
# Usage: ./scripts/run-worker.sh <task-id>
#
# Description:
#   Runs a worker agent for a specific task in an isolated git worktree.
#   This is useful for manually triggering work on a specific task outside
#   of the orchestrator loop.
# ==============================================================================
set -euo pipefail

TASK_ID=${1:?Usage: run-worker.sh <task-id>}
WORKTREE_BASE="../worktrees"
WORKTREE="${WORKTREE_BASE}/${TASK_ID}"
BRANCH="agent/${TASK_ID}"

log() { echo "[$(date '+%H:%M:%S')] $*"; }

# Verify task exists
if ! bd show "$TASK_ID" > /dev/null 2>&1; then
    echo "Error: Task not found: $TASK_ID"
    echo ""
    echo "Available tasks:"
    bd list --json | jq -r '.[] | "  \(.id): \(.title // .subject)"' 2>/dev/null || echo "  (none)"
    exit 1
fi

log "Starting worker for: $TASK_ID"

# Create worktree if needed
if [ ! -d "$WORKTREE" ]; then
    log "Creating worktree: $WORKTREE"
    mkdir -p "$WORKTREE_BASE"
    git worktree add "$WORKTREE" -b "$BRANCH" 2>/dev/null || \
        git worktree add "$WORKTREE" "$BRANCH" 2>/dev/null || {
            echo "Error: Failed to create worktree"
            exit 1
        }
fi

# Update beads status
log "Updating task status to in_progress"
bd update "$TASK_ID" --status in_progress --add-label "phase:spawned" 2>/dev/null || true

# Run worker agent
log "Running worker agent in: $WORKTREE"
cd "$WORKTREE"

# Substitute task ID in prompt
if [ -f ".claude/agents/worker.md" ]; then
    PROMPT=$(cat .claude/agents/worker.md | sed "s/\\\$TASK_ID/$TASK_ID/g")
    log "Invoking Claude with worker prompt..."
    claude --print "$PROMPT"
else
    log "Warning: Worker prompt not found at .claude/agents/worker.md"
    log "Using fallback prompt..."
    claude --print "Execute beads task $TASK_ID. Run 'bd show $TASK_ID' to see details. Follow TDD workflow and run 'just check' before committing."
fi

log "Worker agent completed"
