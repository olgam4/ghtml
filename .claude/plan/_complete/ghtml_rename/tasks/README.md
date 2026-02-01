# Tasks

## Overview

This directory contains individual task specifications for the ghtml rename epic. Each task is designed to be independently executable once its dependencies are satisfied.

## Task Naming Convention

Tasks are named with a three-digit prefix followed by a descriptive name:
- `001_github_rename.md`
- `002_extension_references.md`
- etc.

The numbering indicates required execution order due to dependencies.

## Task Status

| # | Task | Status | Notes |
|---|------|--------|-------|
| 001 | GitHub Rename | [x] Complete | Repository renamed to ghtml |
| 002 | Extension References | [x] Complete | Updated .lustre → .ghtml in source |
| 003 | Module Structure | [x] Complete | Renamed directories and gleam.toml |
| 004 | Source Imports | [x] Complete | Updated imports in src/ |
| 005 | Test Imports | [x] Complete | Updated imports in test/ |
| 006 | Template Files | [x] Complete | Renamed .lustre → .ghtml files |
| 007 | Justfile | [x] Complete | Updated build commands |
| 008 | Documentation | [x] Complete | Updated all docs |
| 009 | Assets | [x] Complete | Updated GIF scripts |
| 010 | Verification | [x] Complete | Final test suite passed |

Status legend:
- `[ ] Pending` - Not started
- `[~] In Progress` - Currently being worked on
- `[x] Complete` - Finished and verified
- `[!] Blocked` - Waiting on external dependency

## Execution Guidelines

1. **Task 001 requires user action** - The user must manually rename the GitHub repository
2. **Sequential execution** - Each task depends on the previous one
3. **Verify after each task** - Run `gleam build` to catch errors early
4. **Full verification at end** - Task 010 runs complete test suite

## File Counts

- Source files to modify: 8
- Test files to modify: ~15
- Template files to rename: ~57
- Documentation files: 5
- Config files: 2
