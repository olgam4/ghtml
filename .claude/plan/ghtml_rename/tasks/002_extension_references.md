# Task 002: Update Extension References

## Description

Update all references to the `.lustre` file extension to `.ghtml` in the source code. This includes string literals, documentation comments, and variable names that reference the extension.

## Dependencies

- Task 001: GitHub Rename (user must confirm completion)

## Success Criteria

1. All `.lustre` string literals changed to `.ghtml`
2. All doc comments mentioning `.lustre` updated
3. Variable names like `lustre_path` renamed to `ghtml_path`
4. `gleam build` succeeds (tests may fail until imports updated)

## Implementation Steps

### 1. Update scanner.gleam

**File:** `src/lustre_template_gen/scanner.gleam`

```gleam
// Line ~50: Change extension in find_recursive call
find_recursive(root, [], ".ghtml")

// Line ~55: Update function and string
/// Converts a .ghtml path to its .gleam output equivalent
pub fn to_gleam_path(ghtml_path: String) -> String {
  string.replace(ghtml_path, ".ghtml", ".gleam")
}

// Line ~60: Update function and string
/// Converts a .gleam path back to its .ghtml source equivalent
pub fn to_ghtml_path(gleam_path: String) -> String {
  string.replace(gleam_path, ".gleam", ".ghtml")
}

// Update doc comments:
// - "Finds all .ghtml template files"
// - "Find orphaned generated files (files with no matching .ghtml source)"
// - "Cleanup orphaned generated files (files with no matching .ghtml source)"
```

### 2. Update cache.gleam

**File:** `src/lustre_template_gen/cache.gleam`

```gleam
// Update the header string (will be updated again in task 004 for module name)
<> "// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen\n"
// Keep as lustre_template_gen for now - will change in task 004
```

### 3. Update codegen.gleam

**File:** `src/lustre_template_gen/codegen.gleam`

```gleam
// Line ~73: Update fallback filename
|> result.unwrap("unknown.ghtml")
```

### 4. Update parser.gleam

**File:** `src/lustre_template_gen/parser.gleam`

```gleam
// Line 1: Update doc comment
//// Template parser for `.ghtml` files.
```

### 5. Update watcher.gleam

**File:** `src/lustre_template_gen/watcher.gleam`

```gleam
// Line 1-2: Update doc comments
//// Monitors `.ghtml` files for changes and triggers automatic regeneration

// Line ~X: Update comment
/// Get modification times for all .ghtml files in a directory tree.
```

### 6. Update main module

**File:** `src/lustre_template_gen.gleam`

```gleam
// Line 1: Update doc comment
//// A preprocessor that converts `.ghtml` template files into Gleam modules
```

## Verification Checklist

- [ ] `grep -r "\.lustre" src/` returns no results (except in strings being replaced)
- [ ] All doc comments updated
- [ ] Variable names updated (lustre_path → ghtml_path)
- [ ] `gleam build` succeeds

## Notes

- The CLI command references (`gleam run -m lustre_template_gen`) will be updated in task 004 along with module renames
- Focus only on `.lustre` extension references in this task

## Files to Modify

- `src/lustre_template_gen/scanner.gleam`
- `src/lustre_template_gen/cache.gleam` (partial - just extension mention if any)
- `src/lustre_template_gen/codegen.gleam`
- `src/lustre_template_gen/parser.gleam`
- `src/lustre_template_gen/watcher.gleam`
- `src/lustre_template_gen.gleam`
