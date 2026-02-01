# Requirements

Requirements use EARS (Easy Approach to Requirements Syntax).

## Patterns
- **Event-driven**: WHEN <trigger> THE <system> SHALL <response>
- **State-driven**: WHILE <condition> THE <system> SHALL <response>
- **Complex**: WHILE <condition> WHEN <trigger> THE <system> SHALL <response>

---

## REQ-001: Task State Query

WHEN an agent needs current task state
THE orchestrator SHALL query Beads via `bd ready` or `bd list --json`
AND return only tasks matching the epic filter

**Acceptance Criteria:**
- [x] `bd ready` returns unblocked tasks
- [x] `bd list --json` returns full state
- [x] Epic filtering works via labels

---

## REQ-002: Parallel Execution

WHILE multiple tasks are unblocked
THE orchestrator SHALL spawn worker agents in parallel up to max-agents limit
AND each agent SHALL work in an isolated git worktree

**Acceptance Criteria:**
- [x] Multiple agents can run simultaneously
- [x] Each agent has isolated worktree
- [x] Max-agents limit is respected

---

## REQ-003: Crash Recovery

WHEN the orchestrator restarts after a crash
THE orchestrator SHALL reconstruct state from Beads labels and local state file
AND resume operations without duplicate work or data loss

**Acceptance Criteria:**
- [x] State reconstruction from Beads labels
- [x] Local state file for runtime data (PIDs, worktrees)
- [x] No duplicate work after recovery

---

## REQ-004: Agent Crash Detection

WHILE a task is in_progress
WHEN the agent PID is no longer running
THE orchestrator SHALL detect the stale PID
AND respawn the agent or advance the task phase based on committed work

**Acceptance Criteria:**
- [x] PID tracking in local state file
- [x] Dead process detection
- [x] Automatic respawn logic

---

## REQ-005: PR Auto-Merge

WHILE CI checks are passing AND PR has no merge conflicts
WHEN the merger agent runs
THE merger agent SHALL squash-merge the PR AND delete the branch AND close the Beads task

**Acceptance Criteria:**
- [x] CI status checking
- [x] Merge conflict detection
- [x] Automatic squash-merge
- [x] Branch cleanup

---

## REQ-006: Spec Discovery

WHEN an agent explores the codebase for context
THE agent SHALL be able to discover specs via Grep/Glob on `.specs/`
AND find related tasks via Beads metadata links

**Acceptance Criteria:**
- [x] Specs discoverable via filesystem search
- [x] Tasks link to specs via labels

---

## REQ-007: State Single Source

THE system SHALL store execution state only in Beads (labels for phase)
AND runtime data in local state file (PIDs, worktrees)
AND specs/research only in `.specs/` markdown files

**Acceptance Criteria:**
- [x] Phase tracking via Beads labels
- [x] Runtime state in `.beads/orchestrator/state.json`
- [x] Specs in `.specs/` directory
