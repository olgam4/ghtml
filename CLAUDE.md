# Codebase Context

Read `CODEBASE.md` for architecture overview, module guide, and key patterns before implementing any task. Update `CODEBASE.md` after completing implementations that add new modules, change architecture, or introduce new patterns.

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
See the Quick Reference table in `CODEBASE.md` for all commands. Key ones:
- `just check` - Run all quality checks before committing
- `just ci` - Simulate CI pipeline before pushing

# Epic-Based Work

The `.plan/` directory organizes multi-session work into epics with tasks.

## Directory Structure

```
.plan/
├── _template/                    # Templates for creating new epics
│   ├── PLAN.md                   # Epic plan template
│   └── tasks/
│       ├── README.md             # Tasks overview template
│       └── 000_template_task.md  # Individual task template
├── initial_implementation/       # Example completed epic
│   ├── PLAN.md                   # High-level epic plan
│   └── tasks/
│       ├── README.md             # Task overview and status
│       ├── 001_project_setup.md  # Individual task specs
│       └── ...
└── [next_epic]/                  # Future epics follow same structure
```

## Creating a New Epic

1. Run: `just epic your_epic_name`
2. Edit `.plan/your_epic_name/PLAN.md` with your epic's details
3. Create task files from `tasks/000_template_task.md`
4. Update `tasks/README.md` with task status tracking

## Task Tracking

When working on tasks from `.plan/<epic>/tasks/`:

**Before starting a task:**
- Update status in `.plan/<epic>/tasks/README.md` from `[ ] Pending` to `[~] In Progress`

**After completing a task:**
- Check off items in the task's verification checklist
- Update status from `[~] In Progress` to `[x] Complete`
- Update the completion checklist in `.plan/<epic>/PLAN.md` if one exists
- Include tracking file updates in your commit

**If blocked:**
- Update status to `[!] Blocked` with a note explaining the blocker

## Task Execution Guidelines

- Tasks are designed to leave the codebase in a working state
- Each task should result in a single atomic commit
- Follow TDD: write tests first, then implement
- Run `just check` before marking a task complete

# Git Guidelines

Commit message format:
```
concise description of what was done

epic: epic_name
task: task_name
```

Example:
```
implemented parser tokenizer logic

epic: initial_implementation
task: 005_parser_tokenizer
```

- Push changes to remote after committing
