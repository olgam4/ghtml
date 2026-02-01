# Task 003: Extract Shared Utilities

## Description

Identify and extract code from `codegen.gleam` that will be shared across all targets. This includes:
- File header generation (`// @generated`, `// @hash`)
- Whitespace collapsing
- Expression formatting utilities

## Dependencies

- Task 001 (directory structure exists)

## Success Criteria

1. Shared utility functions identified
2. Functions remain in `codegen.gleam` (will be shared via import)
3. Clear documentation of what's shared vs target-specific
4. All existing tests pass

## Implementation Steps

### 1. Analyze codegen.gleam

Read and categorize all functions:

**Shared (target-agnostic):**
- `extract_filename()` - Extract filename from path
- Whitespace collapsing logic (`normalize_whitespace`, `collapse_spaces`, `is_blank`)
- String escaping (`escape_string`)

**Lustre-specific (to be moved in Task 004):**
- `generate_imports()` - Import generation (lustre/element, etc.)
- `generate_function()` - Function generation with Element return type
- `generate_node_inline()` and all node generators
- Element rendering (html.div, etc.)
- Attribute mapping (attribute.class, etc.)
- Event handling (event.on_click, etc.)
- `keyed()`, `fragment()`, `none()`, `text()` usage
- `template_needs_*()` functions
- `known_attributes` constant
- `void_elements` constant
- `boolean_attributes` constant

### 2. Document the categorization

Add comments in `codegen.gleam` marking sections:

```gleam
// ============================================================
// SHARED UTILITIES (used by all targets)
// ============================================================

/// Extract the filename from a full path
fn extract_filename(path: String) -> String { ... }

/// Escape special characters in a string for Gleam code
fn escape_string(s: String) -> String { ... }

/// Normalize whitespace by collapsing multiple spaces/tabs to single spaces
fn normalize_whitespace(text: String) -> String { ... }

// ============================================================
// LUSTRE TARGET (to be extracted to target/lustre.gleam)
// ============================================================
```

### 3. Make shared utilities public

Change visibility of shared functions from `fn` to `pub fn`:

```gleam
pub fn extract_filename(path: String) -> String { ... }
pub fn escape_string(s: String) -> String { ... }
pub fn normalize_whitespace(text: String) -> String { ... }
pub fn collapse_spaces(...) -> List(String) { ... }
pub fn is_blank(text: String) -> Bool { ... }
```

## Test Cases

No new tests - this is analysis and documentation only. Existing tests verify functionality.

## Verification Checklist

- [ ] All functions categorized as shared or target-specific
- [ ] Comments added to mark sections
- [ ] Shared utilities made public
- [ ] No functional changes
- [ ] All existing tests pass

## Notes

- This task is primarily analysis and preparation
- The actual extraction of Lustre code happens in Task 004
- Keep the shared utilities minimal - only extract what's truly target-agnostic
- The header generation is in `cache.gleam` (`generate_header`), not codegen

## Files to Modify

- `src/ghtml/codegen.gleam` - Add section comments, make shared utilities public
