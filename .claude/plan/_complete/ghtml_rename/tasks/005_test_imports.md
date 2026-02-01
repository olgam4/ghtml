# Task 005: Update Test Imports

## Description

Update all import statements in test files to reference the new `ghtml/` module path instead of `lustre_template_gen/`. Also update any function calls that reference the old module name.

## Dependencies

- Task 004: Source Imports

## Success Criteria

1. All test imports updated from `lustre_template_gen/*` to `ghtml/*`
2. All function calls using `lustre_template_gen.` prefix updated to `ghtml.`
3. `gleam build` succeeds
4. `just unit` passes

## Implementation Steps

### 1. Update test/unit/scanner_test.gleam

```gleam
// Before
import lustre_template_gen/scanner

// After
import ghtml/scanner
```

### 2. Update test/unit/cli_test.gleam

```gleam
// Before
import lustre_template_gen
import lustre_template_gen/cache
import lustre_template_gen/codegen
import lustre_template_gen/parser
import lustre_template_gen/scanner

// After
import ghtml
import ghtml/cache
import ghtml/codegen
import ghtml/parser
import ghtml/scanner

// Also update function calls:
// Before
let options = lustre_template_gen.parse_options([])
let stats = lustre_template_gen.generate_all(test_dir, False)

// After
let options = ghtml.parse_options([])
let stats = ghtml.generate_all(test_dir, False)
```

### 3. Update test/unit/cache_test.gleam

```gleam
// Before
import lustre_template_gen/cache

// After
import ghtml/cache
```

### 4. Update test/unit/watcher_test.gleam

```gleam
// Before
import lustre_template_gen/scanner

// After
import ghtml/scanner
```

### 5. Update test/unit/types_test.gleam

```gleam
// Before
import lustre_template_gen/types

// After
import ghtml/types
```

### 6. Update test/unit/parser/*.gleam files

**tokenizer_test.gleam:**
```gleam
// Before
import lustre_template_gen/parser
import lustre_template_gen/types

// After
import ghtml/parser
import ghtml/types
```

**ast_test.gleam:**
```gleam
// Before
import lustre_template_gen/parser
import lustre_template_gen/types

// After
import ghtml/parser
import ghtml/types
```

### 7. Update test/unit/codegen/*.gleam files

**basic_test.gleam, attributes_test.gleam, control_flow_test.gleam, imports_test.gleam:**
```gleam
// Before
import lustre_template_gen/codegen
import lustre_template_gen/parser
import lustre_template_gen/types
import lustre_template_gen/cache

// After
import ghtml/codegen
import ghtml/parser
import ghtml/types
import ghtml/cache
```

### 8. Update test/integration/pipeline_test.gleam

```gleam
// Before
import lustre_template_gen/...

// After
import ghtml/...
```

### 9. Update test/e2e/*.gleam files

Check and update any e2e test files that import the modules.

### 10. Verify Tests

```bash
gleam build
just unit
```

## Verification Checklist

- [ ] All imports in test/ use `ghtml/` prefix
- [ ] All `lustre_template_gen.function()` calls updated to `ghtml.function()`
- [ ] `gleam build` succeeds
- [ ] `just unit` passes
- [ ] `grep -r "lustre_template_gen" test/` returns no results

## Notes

- There are approximately 15 test files to update
- The cli_test.gleam file has both imports AND function calls to update
- E2E tests may have fewer changes as they test generated output

## Files to Modify

- `test/unit/scanner_test.gleam`
- `test/unit/cli_test.gleam`
- `test/unit/cache_test.gleam`
- `test/unit/watcher_test.gleam`
- `test/unit/types_test.gleam`
- `test/unit/parser/tokenizer_test.gleam`
- `test/unit/parser/ast_test.gleam`
- `test/unit/codegen/basic_test.gleam`
- `test/unit/codegen/attributes_test.gleam`
- `test/unit/codegen/control_flow_test.gleam`
- `test/unit/codegen/imports_test.gleam`
- `test/integration/pipeline_test.gleam`
- `test/e2e/*.gleam` (as needed)
