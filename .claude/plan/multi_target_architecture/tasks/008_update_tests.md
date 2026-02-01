# Task 008: Update Test Imports

## Description

Update all test files to use the new module structure. Some tests may need to import from `ghtml/target/lustre` instead of `ghtml/codegen`, and all tests calling `codegen.generate()` need to pass the target parameter.

## Dependencies

- Task 004 (Lustre target implemented)
- Task 005 (codegen dispatcher implemented)

## Success Criteria

1. All tests compile
2. All tests pass
3. No deprecated imports
4. Tests cover both direct lustre.generate() and codegen.generate() with target

## Implementation Steps

### 1. Find all test files that import codegen

```bash
grep -r "import ghtml/codegen" test/
```

Expected files:
- `test/unit/codegen/basic_test.gleam`
- `test/unit/codegen/attributes_test.gleam`
- `test/unit/codegen/control_flow_test.gleam`
- `test/unit/codegen/imports_test.gleam`
- `test/integration/pipeline_test.gleam`

### 2. Update imports in each test file

For tests that test Lustre-specific behavior, add lustre import:

```gleam
// Before
import ghtml/codegen
import ghtml/types

// After
import ghtml/codegen
import ghtml/target/lustre
import ghtml/types
```

### 3. Update test function calls

All calls to `codegen.generate()` need the target parameter:

```gleam
// Before
let result = codegen.generate(template, "test.ghtml", "hash")

// After
let result = codegen.generate(template, "test.ghtml", "hash", types.Lustre)
```

### 4. Add tests for direct lustre.generate() calls

For thorough coverage, some tests should call `lustre.generate()` directly:

```gleam
pub fn lustre_generate_direct_test() {
  let template = types.Template(imports: [], params: [], body: [])
  let result = lustre.generate(template, "test.ghtml", "abc123")
  result |> should.contain("// @generated")
}
```

### 5. Update each test file

#### test/unit/codegen/basic_test.gleam
- Add `import ghtml/types.{Lustre}` if not present
- Update all `codegen.generate()` calls to include `types.Lustre` as 4th param

#### test/unit/codegen/attributes_test.gleam
- Add `import ghtml/types.{Lustre}` if not present
- Update all `codegen.generate()` calls

#### test/unit/codegen/control_flow_test.gleam
- Add `import ghtml/types.{Lustre}` if not present
- Update all `codegen.generate()` calls

#### test/unit/codegen/imports_test.gleam
- Add `import ghtml/types.{Lustre}` if not present
- Update all `codegen.generate()` calls

#### test/integration/pipeline_test.gleam
- Update `ghtml.generate_all()` calls to include target

## Test Cases

Run the full test suite:

```bash
just test
```

All tests should pass.

## Verification Checklist

- [ ] All test files compile
- [ ] All unit tests pass
- [ ] All integration tests pass
- [ ] `just test` passes
- [ ] `just check` passes

## Notes

- This is a mechanical task - find and replace with care
- Keep tests testing the same behavior, just with updated API
- Consider adding a few tests that specifically test the dispatcher behavior
- The lustre module can be tested directly for Lustre-specific behavior

## Files to Modify

- `test/unit/codegen/basic_test.gleam` - Update imports and generate calls
- `test/unit/codegen/attributes_test.gleam` - Update imports and generate calls
- `test/unit/codegen/control_flow_test.gleam` - Update imports and generate calls
- `test/unit/codegen/imports_test.gleam` - Update imports and generate calls
- `test/integration/pipeline_test.gleam` - Update imports and generate_all calls
