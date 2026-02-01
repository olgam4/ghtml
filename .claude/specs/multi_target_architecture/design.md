# Design

## Overview

The multi-target architecture separates target-agnostic template processing from target-specific code generation. The parser produces a `Template` AST that any target can consume, and each target module knows how to generate its specific output format.

## Components

### Target Type (`types.gleam`)
```gleam
pub type Target {
  Lustre
  // Future: StringTree, String
}
```

### Target Modules (`src/ghtml/target/`)
- `lustre.gleam` - Generates Lustre `Element(msg)` code
- Future: `stringtree.gleam`, `string.gleam`

### Codegen Dispatcher (`codegen.gleam`)
```gleam
pub fn generate(template: Template, source: String, hash: String, target: Target) -> String {
  case target {
    Lustre -> lustre.generate(template, source, hash)
    // Future targets here
  }
}
```

## Data Flow

```
                                    ┌─────────────────────┐
                                    │  target/lustre.gleam│ → Element(msg)
                                    └─────────────────────┘
.ghtml → parser.gleam → Template ──►┌─────────────────────┐
                                    │target/stringtree.gleam│ → StringTree (future)
                                    └─────────────────────┘
                                    ┌─────────────────────┐
                                    │  target/string.gleam│ → String (future)
                                    └─────────────────────┘
```

## Interfaces

### CLI Flag
```bash
gleam run -m ghtml -- --target=lustre  # Explicit
gleam run -m ghtml                      # Default (lustre)
```

### Generate Function Signature
```gleam
// Before (implicit Lustre)
pub fn generate(template: Template, source_path: String, hash: String) -> String

// After (explicit target)
pub fn generate(template: Template, source_path: String, hash: String, target: Target) -> String
```

## Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| "target" terminology | Clear, consistent | "backend", "output" |
| 1:1 file mapping | Simple, predictable | Multiple outputs per template |
| CLI/config only | Simplicity | Per-template `@target()` directive |
| Events error in non-Lustre | Safety | Warning only, ignore |

## Error Handling

### Invalid Target
- CLI reports error with valid options
- Clear error message

### Events in Non-Lustre Target
- Compile error (future implementation)
- Events only make sense for Lustre/interactive targets

### Backwards Compatibility
- Default target is `lustre`
- Existing usage unchanged
- All existing tests pass
