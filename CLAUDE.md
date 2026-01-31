# Codebase Context
Read `CODEBASE.md` first for architecture overview, module guide, and key patterns before implementing any task. Update `CODEBASE.md` after completing implementations that add new modules, change architecture, or introduce new patterns.

# Use Test Driven Development
1. Implement tests for the change that fail
2. Implement the simplest implementation that succeed the test cases
3. Refactor code to reach the least complex state where the code is:
   * Most maintainable
   * Extendible for future changes
   * Uses the most idiomatic approaches of the language and framework
   * Identify and fix any gaps/misses/edge cases
   * Documentation comments are explaining usage

# Test your changes
* Use `just check` to run all quality checks (build, test, integration, format, docs)
* Use `just ci` to simulate CI pipeline before pushing
* Use `just g <cmd>` to pass any command to gleam (e.g., `just g test`, `just g build`)

# Complete changes
* Commit message should mention task id/name and short/concise description, ex: `005_parser_tokenizer: implemented parser tokenizer logic`
* Commit your changes
* Push changes to remote

# Task Tracking (for epic-based work)
When working on tasks from `.plan/<epic>/tasks/`:

1. **Before starting a task:**
   - Update the task status in `.plan/<epic>/tasks/README.md` from `[ ] Pending` to `[~] In Progress`

2. **After completing a task:**
   - Check off items in the task's verification checklist (the `- [ ]` items in the task file)
   - Update the task status in `.plan/<epic>/tasks/README.md` from `[~] In Progress` to `[x] Complete`
   - Update the completion checklist in `.plan/<epic>/PLAN.md` if one exists
   - Include these tracking file updates in your commit

3. **If blocked:**
   - Update status to `[!] Blocked` with a note explaining the blocker
