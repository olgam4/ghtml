# Design

## Overview

The parallel orchestration system enables multiple AI agents to work on tasks concurrently using:
- **Beads** - Git-backed task queue with dependency tracking
- **Git worktrees** - Isolated working directories per agent
- **GitHub PRs** - Review gate and CI integration
- **Merger agent** - Automated PR review and merge

## Components

### Orchestrator (`scripts/orchestrate.sh`)
- Polls Beads for ready tasks
- Spawns worker agents in isolated worktrees
- Monitors agent health via PID tracking
- Respawns crashed agents

### Worker Agent (`scripts/run-worker.sh` + `.claude/agents/worker.md`)
- Receives task ID and works in isolated worktree
- Follows TDD workflow
- Creates PR when complete
- Updates Beads with phase progress

### Merger Agent (`scripts/run-merger.sh` + `.claude/agents/merger.md`)
- Reviews PRs from worker agents
- Checks CI status and mergeability
- Auto-merges approved PRs
- Cleans up worktrees and branches

## Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                        ORCHESTRATOR                              │
│  (Crash-resilient - reconstructs from Beads + local state)      │
├─────────────────────────────────────────────────────────────────┤
│   Beads ──▶ Worktree Spawner ──▶ Worker Agents ──▶ PRs          │
│     │         (parallel)            (parallel)       │           │
│     └───────────────────────────────────────────────▶ Merger    │
└─────────────────────────────────────────────────────────────────┘
```

### Task State Machine

```
status: open           status: in_progress              status: closed
┌──────────┐          ┌─────────────────────┐          ┌──────────┐
│  Ready   │─────────▶│ phase:spawned       │          │  Done    │
│  (queue) │          │ phase:working       │─────────▶│          │
└──────────┘          │ phase:committed     │          └──────────┘
                      │ phase:pr_created    │
                      │ phase:merged        │
                      └─────────────────────┘
```

## Interfaces

### Phase Tracking (Beads Labels)
- `phase:spawned` - Worktree created, agent starting
- `phase:working` - Agent actively implementing
- `phase:committed` - Changes committed, ready for PR
- `phase:pr_created` - PR created, awaiting merge
- `phase:merged` - PR merged, task complete

### Runtime State (Local File)
Location: `.beads/orchestrator/state.json`

```json
{
  "ghtml-a1b2": {
    "pid": "12345",
    "worktree": "../worktrees/ghtml-a1b2",
    "pr_number": "42"
  }
}
```

## Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| Labels for phase tracking | Git-portable, queryable via `bd list --json` | Metadata (not supported), separate files |
| Local file for runtime state | PIDs/worktrees are machine-specific | Beads metadata, environment variables |
| Stateless orchestrator | Crash resilience, can restart at any time | Persistent state, database |
| Git worktrees for isolation | Native git, no conflicts during work | Docker containers, separate clones |

## Error Handling

### Crash Recovery
1. Orchestrator reads in-progress tasks from Beads
2. Checks local state file for PIDs
3. Validates if processes still running
4. Respawns dead agents
5. Continues from last phase

### Orphaned Worktrees
- Detected when worktree exists but no matching Beads task
- Cleaned up via `just worktree-clean`

### Merge Conflicts
- Detected by merger agent
- PR flagged for manual resolution
- Agent can attempt rebase
