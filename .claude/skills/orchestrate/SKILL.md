---
name: orchestrate
description: Execute an epic to completion via subagents
disable-model-invocation: true
argument-hint: [epic-name]
---

# Orchestrate Epic: $ARGUMENTS

## Current Task Status
!`cat .plan/$ARGUMENTS/tasks/README.md 2>/dev/null || echo "Epic '$ARGUMENTS' not found in .plan/"`

## Algorithm

Follow `ORCHESTRATOR.md`:

1. Find first `[ ] Pending` or `[~] In Progress` task from status above
2. For each task sequentially:
   - Update status to `[~] In Progress`
   - Spawn subagent with: "Read SUBAGENT.md and execute task at .plan/$ARGUMENTS/tasks/<task_file>.md"
   - Wait for completion
   - On success: run `just check`, update to `[x] Complete`, push
   - On failure: retry once with error context, then mark `[!] Blocked` and stop
3. When no pending tasks remain, report epic complete

## Recovery

If resuming an interrupted epic, continue from the first incomplete task shown above.
