# Task 009: Update Documentation

## Description

Update CODEBASE.md to reflect the new multi-target architecture.

## Dependencies

- Task 008 (all tests passing with new structure)

## Success Criteria

1. Architecture diagram updated
2. Module guide updated with target/ modules
3. New Target type documented
4. CLI --target flag documented

## Implementation Steps

### 1. Update architecture diagram

Replace the existing diagram in `.claude/CODEBASE.md`:

```
                    ┌──────────────────────────────────────────────────────────┐
                    │                    CLI Entry Point                        │
                    │                      ghtml.gleam                          │
                    │  - Parses CLI args (force, clean, watch, target)          │
                    │  - Orchestrates scanning → generation → cleanup           │
                    └───────────────────────┬──────────────────────────────────┘
                                            │
        ┌───────────────────────────────────┼───────────────────────────────────┐
        │                                   │                                   │
        ▼                                   ▼                                   ▼
┌───────────────────┐            ┌──────────────────────┐            ┌───────────────────┐
│     scanner       │            │       parser         │            │      watcher      │
│  - Find .ghtml    │            │  - tokenize()        │            │  - OTP actor      │
│  - Find .gleam    │            │  - build_ast()       │            │  - Poll every 1s  │
│  - Find orphans   │            │  - parse() = both    │            │  - Track mtimes   │
└───────────────────┘            └──────────┬───────────┘            └───────────────────┘
                                            │
                                            ▼
                    ┌──────────────────────────────────────────────────────────┐
                    │                       codegen                             │
                    │  - Dispatcher: routes to target module by Target type     │
                    │  - Shared utilities (filename extraction, escaping)       │
                    └──────────────────────┬───────────────────────────────────┘
                                           │
                           ┌───────────────┴───────────────┐
                           ▼                               ▼
                    ┌────────────────┐              ┌────────────────┐
                    │ target/lustre  │              │ target/...     │
                    │ → Element(msg) │              │ (future)       │
                    └────────────────┘              └────────────────┘
                                            │
                                            ▼
                    ┌──────────────────────────────────────────────────────────┐
                    │                        cache                              │
                    │  - SHA-256 hashing of source content                      │
                    │  - Hash stored in generated file header                   │
                    │  - Skip regeneration if hash unchanged                    │
                    └──────────────────────────────────────────────────────────┘
```

### 2. Update Module Guide

Add new sections for target modules:

```markdown
### `src/ghtml/types.gleam` - Core Types
All shared types are defined here:
- **Position/Span** - Source locations for error reporting
- **Token** - Lexer output (Import, Params, HtmlOpen, IfStart, etc.)
- **Attr** - Attribute variants (StaticAttr, DynamicAttr, EventAttr, BooleanAttr)
- **Node** - AST nodes (Element, TextNode, ExprNode, IfNode, EachNode, CaseNode, Fragment)
- **Template** - Final parsed result with imports, params, and body nodes
- **Target** - Code generation target (Lustre, future: StringTree, String)

### `src/ghtml/codegen.gleam` - Code Generator Dispatcher
Thin dispatcher that routes to target-specific modules:
- `generate(template, source_path, hash, target) -> String`
- Dispatches based on `Target` type
- Contains shared utilities used by all targets:
  - `extract_filename()` - Extract filename from path
  - `escape_string()` - Escape special characters for Gleam strings
  - `normalize_whitespace()` - Collapse whitespace
  - `is_blank()` - Check for blank strings

### `src/ghtml/target/lustre.gleam` - Lustre Target
Generates Gleam code that produces Lustre `Element(msg)` values:
- `generate(template, source_path, hash) -> String`
- Smart imports: only includes `gleam/list` if `{#each}` is used, etc.
- Handles attribute mapping (class→attribute.class, @click→event.on_click)
- Custom elements (tags with `-`) use `element("tag-name", ...)` instead of `html.tag()`
- Full support for event handlers
- SSR via `element.to_string()`
```

### 3. Update Quick Reference table

Add the --target flag:

```markdown
## Quick Reference

| Task | Command |
|------|---------|
| Run all checks | `just check` |
| Run all tests | `just test` |
| Run unit tests | `just unit` |
| Run integration tests | `just integration` |
| Build | `just g build` |
| Run CLI | `just run` |
| Run CLI (explicit target) | `just run -- --target=lustre` |
| Force regenerate | `just run-force` |
| Watch mode | `just run-watch` |
```

### 4. Update CLI Entry Point description

```markdown
### `src/ghtml.gleam` - CLI Entry Point
- Parses command-line arguments (force, clean, watch, root directory, **target**)
- Coordinates the generation pipeline
- Public: `main()`, `generate_all()`, `parse_options()`
- Supports specifying a root directory: `gleam run -m ghtml -- ./my-project`
- Supports target selection: `gleam run -m ghtml -- --target=lustre`
```

### 5. Add Target section to Key Design Decisions

```markdown
## Key Design Decisions

1. **All interpolated values must be `String`** - No automatic type conversion
2. **Expressions are passed verbatim** - The generator doesn't validate Gleam syntax
3. **Whitespace is collapsed** - Multiple spaces/newlines become single space
4. **`{#each}` uses `keyed()`** - For Lustre performance optimization
5. **Boolean attrs differ by element type** - Standard HTML vs custom elements
6. **Imports are conditional** - Only include what's actually used
7. **Pluggable targets** - Code generation is dispatched by Target type, enabling future StringTree/String targets
```

### 6. Add section for extending with new targets

```markdown
## Adding a New Target

1. Create `src/ghtml/target/new_target.gleam` with:
   ```gleam
   pub fn generate(template: Template, source_path: String, hash: String) -> String
   ```
2. Add variant to `Target` type in `types.gleam`
3. Add case to dispatcher in `codegen.generate()`
4. Add `--target=new_target` handling in `ghtml.parse_options()`
5. Add tests in `test/unit/codegen/` or `test/unit/target/`
```

## Test Cases

No tests - documentation only.

## Verification Checklist

- [ ] Architecture diagram updated with target modules
- [ ] Module guide includes target/ modules
- [ ] Target type documented in types.gleam section
- [ ] CLI --target flag documented
- [ ] Quick Reference updated
- [ ] "Adding a New Target" section added

## Notes

- Keep documentation concise and focused
- Update any outdated information found during the review
- Ensure the diagram renders correctly in markdown viewers

## Files to Modify

- `.claude/CODEBASE.md` - Full documentation update
