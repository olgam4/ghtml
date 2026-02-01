# Task 006: Rename Template Files

## Description

Rename all `.lustre` template files to `.ghtml` extension. This includes test fixtures and all example project templates.

## Dependencies

- Task 005: Test Imports

## Success Criteria

1. All `.lustre` files renamed to `.ghtml`
2. No `.lustre` files remain in the repository
3. `just unit` still passes
4. `just integration` still passes

## Implementation Steps

### 1. Rename Test Fixtures

```bash
# Simple fixture
mv test/fixtures/simple/basic.lustre test/fixtures/simple/basic.ghtml

# Attributes fixture
mv test/fixtures/attributes/all_attrs.lustre test/fixtures/attributes/all_attrs.ghtml

# Control flow fixture
mv test/fixtures/control_flow/full.lustre test/fixtures/control_flow/full.ghtml

# Fragments fixture
mv test/fixtures/fragments/multiple_roots.lustre test/fixtures/fragments/multiple_roots.ghtml

# Custom elements fixture
mv test/fixtures/custom_elements/web_components.lustre test/fixtures/custom_elements/web_components.ghtml

# Edge cases fixture
mv test/fixtures/edge_cases/special.lustre test/fixtures/edge_cases/special.ghtml
```

### 2. Rename Example Templates (Batch Command)

```bash
# Rename all .lustre files to .ghtml in examples
find examples -name "*.lustre" -exec bash -c 'mv "$0" "${0%.lustre}.ghtml"' {} \;
```

Or manually for each example directory:

```bash
# Example 01 - Simple
mv examples/01_simple/src/components/*.lustre examples/01_simple/src/components/*.ghtml 2>/dev/null || true

# Example 02 - Attributes
mv examples/02_attributes/src/components/*.lustre examples/02_attributes/src/components/*.ghtml 2>/dev/null || true

# Example 03 - Events
for f in examples/03_events/src/components/*.lustre; do mv "$f" "${f%.lustre}.ghtml"; done

# Example 04 - Control Flow
for f in examples/04_control_flow/src/components/*.lustre; do mv "$f" "${f%.lustre}.ghtml"; done

# Example 05 - Shoelace
for f in examples/05_shoelace/src/components/*.lustre; do mv "$f" "${f%.lustre}.ghtml"; done

# Example 06 - Material Web
for f in examples/06_material_web/src/components/*.lustre; do mv "$f" "${f%.lustre}.ghtml"; done

# Example 07 - Tailwind
for f in examples/07_tailwind/src/components/*.lustre; do mv "$f" "${f%.lustre}.ghtml"; done

# Example 08 - Complete (has subdirectories)
find examples/08_complete -name "*.lustre" -exec bash -c 'mv "$0" "${0%.lustre}.ghtml"' {} \;
```

### 3. Clean Up Any Temp Files

```bash
# Remove any .lustre files in .test directory
find .test -name "*.lustre" -exec rm {} \; 2>/dev/null || true
```

### 4. Verify No .lustre Files Remain

```bash
find . -name "*.lustre" -not -path "./build/*" -not -path "./.git/*"
# Should return nothing
```

### 5. Regenerate E2E Test Modules

```bash
# The e2e-regen script needs to be updated first (done in justfile task)
# For now, manually regenerate if needed
gleam run -m ghtml -- test/fixtures
```

### 6. Run Tests

```bash
just unit
just integration
```

## Verification Checklist

- [ ] `find . -name "*.lustre" -not -path "./build/*"` returns nothing
- [ ] All 6 fixture files renamed
- [ ] All ~51 example template files renamed
- [ ] `just unit` passes
- [ ] `just integration` passes

## Notes

- There are approximately 57 template files to rename total
- The find/exec command is the safest way to batch rename
- After renaming, existing generated .gleam files will be orphaned until regenerated
- The justfile update (task 007) will fix the e2e-regen script paths

## Files to Rename

### Test Fixtures (6 files)
- `test/fixtures/simple/basic.lustre` → `.ghtml`
- `test/fixtures/attributes/all_attrs.lustre` → `.ghtml`
- `test/fixtures/control_flow/full.lustre` → `.ghtml`
- `test/fixtures/fragments/multiple_roots.lustre` → `.ghtml`
- `test/fixtures/custom_elements/web_components.lustre` → `.ghtml`
- `test/fixtures/edge_cases/special.lustre` → `.ghtml`

### Example Projects (~51 files)
- `examples/01_simple/src/components/*.lustre`
- `examples/02_attributes/src/components/*.lustre`
- `examples/03_events/src/components/*.lustre`
- `examples/04_control_flow/src/components/*.lustre`
- `examples/05_shoelace/src/components/*.lustre`
- `examples/06_material_web/src/components/*.lustre`
- `examples/07_tailwind/src/components/*.lustre`
- `examples/08_complete/src/components/**/*.lustre`
