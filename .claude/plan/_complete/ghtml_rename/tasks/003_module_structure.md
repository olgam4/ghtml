# Task 003: Rename Module Structure

## Description

Rename the module directory structure and update `gleam.toml` to change the package name from `lustre_template_gen` to `ghtml`.

## Dependencies

- Task 002: Extension References

## Success Criteria

1. Directory renamed from `src/lustre_template_gen/` to `src/ghtml/`
2. Main module renamed from `src/lustre_template_gen.gleam` to `src/ghtml.gleam`
3. `gleam.toml` name field updated to `ghtml`
4. Build directory cleaned to avoid stale artifacts

## Implementation Steps

### 1. Clean Build Directory

```bash
rm -rf build
```

### 2. Rename Module Directory

```bash
mv src/lustre_template_gen src/ghtml
```

### 3. Rename Main Module File

```bash
mv src/lustre_template_gen.gleam src/ghtml.gleam
```

### 4. Update gleam.toml

**File:** `gleam.toml`

```toml
# Before
name = "lustre_template_gen"

# After
name = "ghtml"
```

### 5. Verify Structure

```bash
ls -la src/
# Should show:
# src/ghtml.gleam
# src/ghtml/
# src/e2e_helpers.gleam

ls -la src/ghtml/
# Should show:
# cache.gleam
# codegen.gleam
# parser.gleam
# scanner.gleam
# types.gleam
# watcher.gleam
```

## Verification Checklist

- [ ] `src/lustre_template_gen/` no longer exists
- [ ] `src/lustre_template_gen.gleam` no longer exists
- [ ] `src/ghtml/` exists with all module files
- [ ] `src/ghtml.gleam` exists
- [ ] `gleam.toml` has `name = "ghtml"`
- [ ] `build/` directory removed

## Notes

- After this task, `gleam build` will FAIL until imports are updated in tasks 004 and 005
- This is expected - we're doing a two-phase rename (structure first, then imports)
- The e2e_helpers.gleam file stays in src/ root - it doesn't move

## Files to Modify

- `gleam.toml` - update name field
- Directory operations:
  - `mv src/lustre_template_gen src/ghtml`
  - `mv src/lustre_template_gen.gleam src/ghtml.gleam`
