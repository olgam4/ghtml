# Task 007: Update Justfile

## Description

Update the justfile to use the new `ghtml` module name for all CLI commands, and update any file path references from `.lustre` to `.ghtml`.

## Dependencies

- Task 006: Template Files

## Success Criteria

1. All `gleam run -m lustre_template_gen` commands changed to `gleam run -m ghtml`
2. All `.lustre` file references changed to `.ghtml`
3. `just run` works correctly
4. `just e2e-regen` works correctly

## Implementation Steps

### 1. Update CLI Commands

**Lines to change:**

```just
# Line 37 - run command
run:
    gleam run -m ghtml

# Line 40 - run-force command
run-force:
    gleam run -m ghtml -- force

# Line 44 - run-watch command
run-watch:
    gleam run -m ghtml -- watch

# Line 48 - run-clean command
run-clean:
    gleam run -m ghtml -- clean

# Line 59 - check-examples (generates templates)
    gleam run -m ghtml -- examples

# Line 211 - e2e-regen
    gleam run -m ghtml -- test/fixtures
```

### 2. Update e2e-regen Fixture Paths

Update the fixture file references in the e2e-regen recipe:

```just
# Before (around line 200-228)
for fixture in test/fixtures/simple/basic.lustre \
               test/fixtures/attributes/all_attrs.lustre \
               test/fixtures/control_flow/full.lustre \
               test/fixtures/fragments/multiple_roots.lustre \
               test/fixtures/custom_elements/web_components.lustre \
               test/fixtures/edge_cases/special.lustre; do

# After
for fixture in test/fixtures/simple/basic.ghtml \
               test/fixtures/attributes/all_attrs.ghtml \
               test/fixtures/control_flow/full.ghtml \
               test/fixtures/fragments/multiple_roots.ghtml \
               test/fixtures/custom_elements/web_components.ghtml \
               test/fixtures/edge_cases/special.ghtml; do
```

### 3. Update Header Comment

```just
# Before (line 1)
# Lustre Template Generator - Development Commands

# After
# ghtml - Gleam HTML Template Generator
```

### 4. Verify Commands Work

```bash
just run
# Should execute: gleam run -m ghtml

just run-force
# Should execute: gleam run -m ghtml -- force
```

## Verification Checklist

- [ ] `grep "lustre_template_gen" justfile` returns no results
- [ ] `grep "\.lustre" justfile` returns no results
- [ ] `just run` executes successfully
- [ ] `just run-force` executes successfully
- [ ] `just e2e-regen` executes successfully
- [ ] `just check-examples` works (after examples are regenerated)

## Notes

- The justfile uses the module name directly in `gleam run -m` commands
- The e2e-regen recipe has hardcoded fixture paths that need updating
- Comments in the file may also reference the old name

## Files to Modify

- `justfile` - all CLI commands and fixture references
