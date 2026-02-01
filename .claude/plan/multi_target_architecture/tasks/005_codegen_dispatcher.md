# Task 005: Create Codegen Dispatcher

## Description

Refactor `codegen.gleam` to be a thin dispatcher that routes to the appropriate target module based on the `Target` type.

## Dependencies

- Task 002 (Target type defined)
- Task 004 (Lustre target implemented)

## Success Criteria

1. `codegen.generate()` accepts a `Target` parameter
2. Dispatches to `lustre.generate()` for `Lustre` target
3. Has `todo` for future targets (in comments)
4. Shared utilities remain accessible

## Implementation Steps

### 1. Update generate function signature

```gleam
import ghtml/target/lustre
import ghtml/types.{type Target, type Template, Lustre}

/// Generate Gleam source code for a template.
///
/// The target determines what type of code is generated:
/// - Lustre: Produces Element(msg) values
/// - StringTree: (future) Produces StringTree values
/// - String: (future) Produces String values
pub fn generate(
  template: Template,
  source_path: String,
  hash: String,
  target: Target,
) -> String {
  case target {
    Lustre -> lustre.generate(template, source_path, hash)
    // Future targets would be added here:
    // StringTree -> string_tree.generate(template, source_path, hash)
    // String -> string.generate(template, source_path, hash)
  }
}
```

### 2. Keep shared utilities public

Ensure functions like these remain public so targets can import them:

```gleam
/// Extract the filename from a full path. Used by all targets.
pub fn extract_filename(path: String) -> String {
  path
  |> string.split("/")
  |> list.last()
  |> result.unwrap("unknown.ghtml")
}

/// Escape special characters in a string for Gleam code. Used by all targets.
pub fn escape_string(s: String) -> String { ... }

/// Normalize whitespace. Used by all targets.
pub fn normalize_whitespace(text: String) -> String { ... }

/// Check if a string is blank. Used by all targets.
pub fn is_blank(text: String) -> Bool { ... }
```

### 3. Clean up codegen.gleam

After the move, `codegen.gleam` should contain only:
- The `generate()` dispatcher function
- Shared utility functions
- Necessary imports

Remove any Lustre-specific code that was moved to `target/lustre.gleam`.

## Test Cases

```gleam
// test/unit/codegen/basic_test.gleam
pub fn generate_with_lustre_target_test() {
  let template = types.Template(
    imports: [],
    params: [],
    body: [types.Element("div", [], [], types.point_span(types.start_position()))],
  )
  let result = codegen.generate(template, "test.ghtml", "abc123", types.Lustre)
  result |> should.contain("// @generated")
  result |> should.contain("html.div")
}
```

## Verification Checklist

- [ ] `generate()` accepts `Target` parameter
- [ ] Case expression dispatches by target
- [ ] Shared utilities are public
- [ ] All tests updated to pass target
- [ ] `just check` passes

## Notes

- This task changes the public API of `codegen.generate()`
- All callers must be updated (done in Task 007)
- The dispatcher pattern makes adding new targets trivial
- Keep exhaustive pattern matching so new targets cause compile errors

## Files to Modify

- `src/ghtml/codegen.gleam` - Update generate signature, add dispatcher
