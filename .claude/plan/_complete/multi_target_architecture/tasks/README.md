# Tasks

## Overview

This directory contains individual task specifications for the Multi-Target Architecture epic. Each task is designed to be independently executable once its dependencies are satisfied.

## Task Naming Convention

Tasks are named with a three-digit prefix followed by a descriptive name:
- `001_create_target_dir.md`
- `002_define_target_type.md`
- etc.

The numbering indicates a recommended execution order, though tasks can be executed in parallel if their dependencies are satisfied.

## Task Status

| # | Task | Status | Notes |
|---|------|--------|-------|
| 001 | Create target directory structure | [ ] Pending | No dependencies |
| 002 | Define Target type | [ ] Pending | No dependencies, can run parallel with 001 |
| 003 | Extract shared utilities | [ ] Pending | Depends on 001 |
| 004 | Implement Lustre target module | [ ] Pending | Depends on 001, 003 |
| 005 | Create codegen dispatcher | [ ] Pending | Depends on 002, 004 |
| 006 | Add CLI --target flag | [ ] Pending | Depends on 002 |
| 007 | Wire target through pipeline | [ ] Pending | Depends on 005, 006 |
| 008 | Update test imports | [ ] Pending | Depends on 004, 005 |
| 009 | Update documentation | [ ] Pending | Depends on 008 |

Status legend:
- `[ ] Pending` - Not started
- `[~] In Progress` - Currently being worked on
- `[x] Complete` - Finished and verified
- `[!] Blocked` - Waiting on external dependency

## Parallelization Opportunities

The following tasks can be executed in parallel:
- **001 + 002**: Both have no dependencies
- **003 + 006**: After 001 and 002 complete respectively

## Execution Guidelines

1. **Check dependencies first** - Ensure all prerequisite tasks are complete
2. **Follow TDD** - Write tests before implementation (see CLAUDE.md)
3. **Verify success criteria** - All criteria must be met before marking complete
4. **Run full checks** - Use `just check` before marking complete
5. **Commit atomically** - Each task should result in a single commit

## Adding New Tasks

1. Copy `000_template_task.md` from `_template/tasks/` to `NNN_task_name.md`
2. Fill in all sections
3. Update this README with the new task
4. Update the parent PLAN.md task table and dependency graph
