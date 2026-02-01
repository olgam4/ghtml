# Codebase Context

Read `.claude/CODEBASE.md` for architecture overview, module guide, and key patterns before implementing any task. Update `.claude/CODEBASE.md` after completing implementations that add new modules, change architecture, or introduce new patterns.

# Development Workflow

## Test Driven Development
1. Implement tests for the change that fail
2. Implement the simplest implementation that succeeds
3. Refactor to the least complex state:
   - Most maintainable and extendible
   - Uses idiomatic Gleam/Lustre patterns
   - Handles edge cases
   - Includes documentation comments

## Commands
See the Quick Reference table in `.claude/CODEBASE.md` for all commands. Key ones:
- `just check` - Run all quality checks before committing
- `just ci` - Simulate CI pipeline before pushing

## GIF Recording

Regenerate README demos with `just gifs`. See `assets/gif-record/README.md` for prerequisites and details.

# Task Management

All tasks are tracked in **Beads**, a git-backed issue tracker.

## Quick Reference

```bash
# View available work
bd ready              # Tasks ready to work on (no blockers)
bd list               # All tasks
bd show <id>          # Task details

# Work on tasks
just orchestrate      # Run parallel agents
just worker <id>      # Work on single task
just orchestrate-status  # Check progress

# Create work
bd create "Task name" -p 1    # Create task (priority 0-4)
bd dep add <task> <blocker>   # Add dependency
bd close <id>                 # Complete task
```

## Creating Work

```bash
# Create epic with tasks
bd create "Epic: Feature Name" -p 0 --label epic

# Create tasks under epic
bd create "Implement parser" -p 1 --label task

# Add detailed description via comment
bd comment <task-id> "
## Requirements
- Parse X format
- Handle edge cases Y, Z

## Acceptance Criteria
- [ ] Unit tests pass
- [ ] Integration tests pass
"

# Set dependencies between tasks
bd dep add <task-id> <blocker-id>
```

## Detailed Specifications

For complex features requiring detailed specs, use `.claude/specs/`:
- `just new-spec <name>` - Create spec folder with templates
- Specs contain requirements.md, design.md, research/

The `.claude/plan/` directory contains legacy epic/task specifications that can be migrated to Beads using `just migrate-to-beads`.

# Execution Modes

## Automated Mode (Recommended)

For parallel agent execution with PR workflow:
- Status tracked in Beads
- Multiple agents work concurrently
- Automatic PR creation and merging
- See: `.claude/docs/orchestration.md`

```bash
bd init                           # Initialize (first time)
just orchestrate --epic <id>      # Run parallel agents
just merger                       # Process PRs
```

## Manual Mode (Sequential)

For human-orchestrated, step-by-step execution:
- Status tracked via markdown checkboxes
- Single task at a time
- See: `.claude/SUBAGENT.md`

## When to Use Which

| Scenario | Mode |
|----------|------|
| Learning/exploring the codebase | Manual |
| Single focused task | Manual |
| Multiple independent tasks | Automated |
| Want PR review workflow | Automated |
| CI/CD integration | Automated |
