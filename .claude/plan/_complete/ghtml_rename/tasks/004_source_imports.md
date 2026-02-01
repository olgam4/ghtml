# Task 004: Update Source Imports

## Description

Update all import statements in the source files to reference the new `ghtml/` module path instead of `lustre_template_gen/`.

## Dependencies

- Task 003: Module Structure

## Success Criteria

1. All imports updated from `lustre_template_gen/*` to `ghtml/*`
2. CLI command references updated to `gleam run -m ghtml`
3. `gleam build` succeeds
4. No references to `lustre_template_gen` remain in src/

## Implementation Steps

### 1. Update src/ghtml.gleam (main module)

```gleam
// Before
import lustre_template_gen/cache
import lustre_template_gen/codegen
import lustre_template_gen/parser
import lustre_template_gen/scanner
import lustre_template_gen/watcher

// After
import ghtml/cache
import ghtml/codegen
import ghtml/parser
import ghtml/scanner
import ghtml/watcher

// Also update doc comments with CLI commands:
//// gleam run -m ghtml              # Generate all
//// gleam run -m ghtml -- force     # Force regenerate
//// gleam run -m ghtml -- watch     # Watch mode
//// gleam run -m ghtml -- clean     # Remove orphans
```

### 2. Update src/ghtml/watcher.gleam

```gleam
// Before
import lustre_template_gen/cache
import lustre_template_gen/codegen
import lustre_template_gen/parser
import lustre_template_gen/scanner

// After
import ghtml/cache
import ghtml/codegen
import ghtml/parser
import ghtml/scanner
```

### 3. Update src/ghtml/scanner.gleam

```gleam
// Before
import lustre_template_gen/cache

// After
import ghtml/cache
```

### 4. Update src/ghtml/codegen.gleam

```gleam
// Before
import lustre_template_gen/cache
import lustre_template_gen/types.{...}

// After
import ghtml/cache
import ghtml/types.{...}
```

### 5. Update src/ghtml/parser.gleam

```gleam
// Before
import lustre_template_gen/types.{...}

// After
import ghtml/types.{...}
```

### 6. Update src/ghtml/cache.gleam

```gleam
// Update the generated file header CLI reference
// Before
<> "// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen\n"

// After
<> "// DO NOT EDIT - regenerate with: gleam run -m ghtml\n"
```

### 7. Verify Build

```bash
gleam build
```

## Verification Checklist

- [ ] All imports in src/ use `ghtml/` prefix
- [ ] CLI references in comments updated to `ghtml`
- [ ] Generated file header uses `gleam run -m ghtml`
- [ ] `gleam build` succeeds
- [ ] `grep -r "lustre_template_gen" src/` returns no results

## Notes

- The types.gleam and cache.gleam files don't import other local modules, so they don't need import updates (only cache.gleam needs the CLI string update)
- After this task, the source compiles but tests will still fail

## Files to Modify

- `src/ghtml.gleam` - imports and doc comments
- `src/ghtml/watcher.gleam` - imports
- `src/ghtml/scanner.gleam` - imports
- `src/ghtml/codegen.gleam` - imports
- `src/ghtml/parser.gleam` - imports
- `src/ghtml/cache.gleam` - CLI string in header
