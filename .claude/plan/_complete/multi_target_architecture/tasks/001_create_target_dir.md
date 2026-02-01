# Task 001: Create Target Directory Structure

## Description

Create the `src/ghtml/target/` directory and placeholder files for the target modules. This establishes the foundation for the multi-target architecture.

## Dependencies

- None - this is the first task

## Success Criteria

1. Directory `src/ghtml/target/` exists
2. File `src/ghtml/target/lustre.gleam` exists with module stub
3. Project compiles successfully with `gleam build`

## Implementation Steps

### 1. Create directory structure

```bash
mkdir -p src/ghtml/target
```

### 2. Create lustre.gleam stub

Create `src/ghtml/target/lustre.gleam` with a minimal module stub:

```gleam
//// Lustre Element target for ghtml code generation.
////
//// This module generates Gleam code that produces Lustre `Element(msg)` values.
//// It's the default target and provides full support for:
//// - Interactive client-side applications
//// - Server-side rendering via `element.to_string()`
//// - Event handlers (@click, @input, etc.)

import ghtml/types.{type Template}

/// Generate Gleam source code for the Lustre target.
///
/// This function will be populated in Task 004 when we extract
/// the codegen logic from the main codegen module.
pub fn generate(
  _template: Template,
  _source_path: String,
  _hash: String,
) -> String {
  todo as "Will be implemented in Task 004"
}
```

## Test Cases

No new tests needed - just verify the project compiles.

## Verification Checklist

- [ ] `src/ghtml/target/` directory exists
- [ ] `src/ghtml/target/lustre.gleam` exists
- [ ] `gleam build` succeeds
- [ ] `gleam test` passes (existing tests unchanged)

## Notes

- This is a foundational task that sets up the directory structure
- The stub function uses `todo` which will cause a runtime error if called, but compiles fine
- This allows other tasks to import the module while it's being developed

## Files to Modify

- `src/ghtml/target/lustre.gleam` - Create new file
