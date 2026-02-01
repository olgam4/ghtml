# Task 002: Define Target Type

## Description

Add the `Target` type to `types.gleam` that represents the available code generation targets. Initially includes `Lustre` with stubs for future targets.

## Dependencies

- None - can run in parallel with Task 001

## Success Criteria

1. `Target` type defined in `types.gleam`
2. Type includes `Lustre` variant
3. Type includes commented placeholders for `StringTree` and `String`
4. Project compiles successfully

## Implementation Steps

### 1. Add Target type to types.gleam

Add after the `Template` type definition:

```gleam
/// Code generation target.
///
/// Determines what type of Gleam code is generated from templates.
/// The target affects:
/// - Import statements (lustre/* vs gleam/string_tree)
/// - Function return types (Element(msg) vs StringTree vs String)
/// - How control flow is rendered (keyed() vs list.map())
pub type Target {
  /// Lustre Element target (default).
  /// Generates code that produces `Element(msg)` values.
  /// Full support for event handlers, SSR via element.to_string().
  Lustre
  // Future targets:
  // StringTree - Efficient server-side HTML generation
  // String - Simple string concatenation
}
```

## Test Cases

```gleam
// test/unit/types_test.gleam
pub fn target_type_exists_test() {
  // Just verify the type can be constructed
  let target = types.Lustre
  target |> should.equal(types.Lustre)
}
```

## Verification Checklist

- [ ] `Target` type defined in `types.gleam`
- [ ] `Lustre` variant exists
- [ ] Comments document future targets
- [ ] `gleam build` succeeds
- [ ] Test added and passes

## Notes

- The Target type is intentionally simple for now
- Future targets will be added as new variants
- Using an enum allows exhaustive pattern matching in the dispatcher

## Files to Modify

- `src/ghtml/types.gleam` - Add Target type
- `test/unit/types_test.gleam` - Add type existence test
