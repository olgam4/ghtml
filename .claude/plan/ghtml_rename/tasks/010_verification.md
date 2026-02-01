# Task 010: Final Verification

## Description

Run complete verification of the rename by executing all tests, building all examples, and confirming no old references remain.

## Dependencies

- Task 009: Assets

## Success Criteria

1. `just check` passes completely
2. `just examples` builds all examples
3. No references to old naming remain
4. CLI works with new name
5. Generated files use new naming

## Implementation Steps

### 1. Clean Build

```bash
rm -rf build
gleam build
```

### 2. Run Full Test Suite

```bash
just check
```

This runs:
- `gleam build`
- `just unit`
- `just integration`
- `just e2e`
- `just check-examples`
- `gleam format`
- `gleam docs build`

### 3. Verify CLI Works

```bash
# Test basic generation
gleam run -m ghtml

# Test with force flag
gleam run -m ghtml -- force

# Test watch mode (Ctrl+C to exit)
gleam run -m ghtml -- watch &
sleep 2
kill %1

# Test clean
gleam run -m ghtml -- clean
```

### 4. Verify Generated Output

Create a test template and verify output:

```bash
# Create temp test file
mkdir -p /tmp/ghtml-test/src/components
cat > /tmp/ghtml-test/src/components/test.ghtml << 'EOF'
@params(name: String)
<div>{name}</div>
EOF

# Generate
gleam run -m ghtml -- /tmp/ghtml-test

# Check generated file
cat /tmp/ghtml-test/src/components/test.gleam
# Should contain: // DO NOT EDIT - regenerate with: gleam run -m ghtml

# Cleanup
rm -rf /tmp/ghtml-test
```

### 5. Search for Old References

```bash
# Search for old package name
grep -r "lustre_template_gen" . \
  --include="*.gleam" \
  --include="*.md" \
  --include="*.toml" \
  --include="justfile" \
  --exclude-dir=build \
  --exclude-dir=.git \
  --exclude-dir=node_modules

# Search for old extension
grep -r "\.lustre" . \
  --include="*.gleam" \
  --include="*.md" \
  --include="*.sh" \
  --include="justfile" \
  --exclude-dir=build \
  --exclude-dir=.git

# Search for old files
find . -name "*.lustre" \
  -not -path "./build/*" \
  -not -path "./.git/*"
```

All three searches should return no results.

### 6. Verify Examples Build

```bash
just examples
```

### 7. Documentation Build

```bash
gleam docs build
```

### 8. Format Check

```bash
gleam format --check src test
```

## Verification Checklist

- [ ] `just check` passes completely
- [ ] `gleam run -m ghtml` works
- [ ] `gleam run -m ghtml -- force` works
- [ ] Generated files have correct header with `ghtml`
- [ ] No `lustre_template_gen` references found in codebase
- [ ] No `.lustre` files remain
- [ ] All examples build successfully
- [ ] Documentation builds successfully
- [ ] Code is formatted

## Final Summary

After this task, the rename is complete:

| Before | After |
|--------|-------|
| `.lustre` | `.ghtml` |
| `lustre_template_gen` | `ghtml` |
| `gleam run -m lustre_template_gen` | `gleam run -m ghtml` |
| `import lustre_template_gen/...` | `import ghtml/...` |

## Notes

- If any verification step fails, trace back to the relevant task and fix
- Consider creating a single commit for the entire rename or one commit per task
- Update any CI/CD configurations if they reference the old name

## Files to Verify

- All source files in `src/ghtml/`
- All test files in `test/`
- All template files (`.ghtml` extension)
- Configuration files (`gleam.toml`, `justfile`)
- Documentation (`README.md`, `CLAUDE.md`, `.claude/CODEBASE.md`)
