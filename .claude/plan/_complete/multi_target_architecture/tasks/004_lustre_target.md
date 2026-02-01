# Task 004: Implement Lustre Target Module

## Description

Move all Lustre-specific code generation from `codegen.gleam` to `target/lustre.gleam`. This is the largest task in the epic.

## Dependencies

- Task 001 (target directory exists)
- Task 003 (shared utilities identified)

## Success Criteria

1. `target/lustre.gleam` contains all Lustre-specific codegen
2. `target/lustre.gleam` imports shared utilities from `codegen.gleam`
3. `lustre.generate()` produces identical output to current `codegen.generate()`
4. All existing tests pass (may need import updates)

## Implementation Steps

### 1. Copy current generate function to lustre.gleam

Replace the stub with the full implementation:

```gleam
// src/ghtml/target/lustre.gleam

//// Lustre Element target for ghtml code generation.
////
//// This module generates Gleam code that produces Lustre `Element(msg)` values.
//// It's the default target and provides full support for:
//// - Interactive client-side applications
//// - Server-side rendering via `element.to_string()`
//// - Event handlers (@click, @input, etc.)

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import ghtml/cache
import ghtml/codegen  // For shared utilities
import ghtml/types.{
  type Attr, type CaseBranch, type Node, type Template,
  BooleanAttr, CaseNode, DynamicAttr, EachNode, Element, EventAttr,
  ExprNode, Fragment, IfNode, StaticAttr, TextNode,
}

/// Generate Gleam source code for the Lustre target.
pub fn generate(
  template: Template,
  source_path: String,
  hash: String,
) -> String {
  let filename = codegen.extract_filename(source_path)
  let header = cache.generate_header(filename, hash)
  let imports = generate_imports(template)
  let body = generate_function(template)

  header <> "\n" <> imports <> "\n\n" <> body <> "\n"
}
```

### 2. Move all helper functions

Functions to move from `codegen.gleam` to `target/lustre.gleam`:
- `generate_imports()`
- `generate_function()`
- `generate_params()`
- `generate_node_inline()`
- `generate_element_inline()`
- `generate_attrs()`
- `generate_attr()`
- `generate_static_attr()`
- `generate_dynamic_attr()`
- `generate_boolean_attr()`
- `generate_event_attr()`
- `find_attr_function()`
- `generate_text_inline()`
- `generate_children_inline()`
- `generate_if_node_inline()`
- `generate_branch_content()`
- `generate_each_node_inline()`
- `generate_case_node_inline()`
- `generate_fragment_inline()`
- All `template_needs_*()` / `template_has_*()` functions
- All `node_needs_*()` / `node_has_*()` functions
- `has_user_import()`
- `has_non_event_attrs()`
- `has_event_attrs()`
- `is_custom_element()`
- `is_void_element()`

Constants to move:
- `void_elements`
- `known_attributes`
- `boolean_attributes`

### 3. Update codegen.gleam to delegate

Temporarily have `codegen.generate()` delegate to `lustre.generate()`:

```gleam
import ghtml/target/lustre

pub fn generate(
  template: Template,
  source_path: String,
  hash: String,
) -> String {
  lustre.generate(template, source_path, hash)
}
```

### 4. Update shared utility imports in lustre.gleam

Where lustre.gleam uses shared utilities:

```gleam
// Use shared utilities from codegen
let normalized = codegen.normalize_whitespace(content)
case codegen.is_blank(normalized) { ... }
"text(\"" <> codegen.escape_string(normalized) <> "\")"
```

## Test Cases

Existing tests should pass without modification if the delegation works correctly.

Add a specific test to verify Lustre target output:

```gleam
// test/unit/codegen/basic_test.gleam
pub fn lustre_target_generates_element_test() {
  let template = types.Template(
    imports: [],
    params: [],
    body: [types.Element("div", [], [], types.point_span(types.start_position()))],
  )
  let result = lustre.generate(template, "test.ghtml", "abc123")
  result |> should.contain("Element(msg)")
  result |> should.contain("html.div")
}
```

## Verification Checklist

- [ ] All Lustre-specific functions moved to `target/lustre.gleam`
- [ ] Shared utilities remain in `codegen.gleam`
- [ ] `codegen.generate()` delegates to `lustre.generate()`
- [ ] Generated output is byte-for-byte identical
- [ ] All existing tests pass
- [ ] `just check` passes

## Notes

- This is the largest task - take care to move everything correctly
- The delegation approach allows incremental testing
- Keep the function signatures identical during the move
- Use `codegen.` prefix for shared utilities in lustre.gleam

## Files to Modify

- `src/ghtml/target/lustre.gleam` - Full implementation
- `src/ghtml/codegen.gleam` - Remove Lustre code, keep shared, add delegation
