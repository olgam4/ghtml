# Epic: Multi-Target Architecture

## Goal

Establish a pluggable target architecture for ghtml that separates target-agnostic template processing from target-specific code generation. This enables the same `.ghtml` template to generate different output formats (Lustre Element, StringTree, String) via compile-time target selection.

## Background

ghtml currently generates Lustre `Element(msg)` code exclusively. However, the AST (`Template` with `Node` variants) is already format-agnostic—all Lustre-specific code lives in `codegen.gleam`. This epic formalizes that separation by:

1. Extracting Lustre-specific code into `target/lustre.gleam`
2. Creating a target dispatcher in `codegen.gleam`
3. Adding `--target` CLI flag for explicit selection
4. Preparing the architecture for future StringTree/String targets

## Scope

### In Scope
- Create `src/ghtml/target/` directory structure
- Extract Lustre codegen to `target/lustre.gleam`
- Refactor `codegen.gleam` to thin dispatcher
- Add `--target` CLI flag (default: `lustre`)
- Define `Target` type with future variants
- Update all tests to work with new structure
- Update CODEBASE.md documentation

### Out of Scope
- Implementing StringTree target
- Implementing String target
- Per-directory target configuration
- Compile-time validation of events for non-Lustre targets
- HTML escaping utilities (needed later for non-Lustre)

## Design Overview

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

### Key Design Decisions
- **Terminology**: Use "target" (not "backend" or "output")
- **File mapping**: 1:1 (`a.ghtml` → `a.gleam`, content varies by target)
- **Configuration**: CLI/config only, no per-template `@target()` directive
- **Events in non-Lustre**: Compile error (future implementation)

## Task Breakdown

| # | Task | Description | Dependencies |
|---|------|-------------|--------------|
| 001 | Create target directory structure | Set up `src/ghtml/target/` and initial files | None |
| 002 | Define Target type | Add `Target` type to `types.gleam` | None |
| 003 | Extract shared utilities | Identify and extract target-agnostic code from codegen | 001 |
| 004 | Implement Lustre target module | Move Lustre-specific codegen to `target/lustre.gleam` | 001, 003 |
| 005 | Create codegen dispatcher | Refactor `codegen.gleam` to dispatch by target | 002, 004 |
| 006 | Add CLI --target flag | Parse `--target=lustre` flag in CLI | 002 |
| 007 | Wire target through pipeline | Connect CLI flag to codegen dispatcher | 005, 006 |
| 008 | Update test imports | Fix all test files to use new module paths | 004, 005 |
| 009 | Update documentation | Update CODEBASE.md with new architecture | 008 |

## Task Dependency Graph

```
001_create_target_dir ──┬──► 003_extract_shared ──► 004_lustre_target ──┐
                        │                                                │
002_define_target_type ─┼──────────────────────────────────────────────►├──► 005_codegen_dispatcher ──┐
                        │                                                │                             │
                        └──► 006_cli_target_flag ──────────────────────►├─────────────────────────────┼──► 007_wire_pipeline
                                                                         │                             │
                                                                         └──► 008_update_tests ────────┴──► 009_update_docs
```

## Success Criteria

1. `gleam run -m ghtml` produces identical output to before (backwards compatible)
2. `gleam run -m ghtml -- --target=lustre` works explicitly
3. All existing tests pass
4. Architecture clearly separates target-agnostic from Lustre-specific code
5. Adding a new target only requires creating `target/new_target.gleam` and updating dispatcher

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Breaking existing API | High | Maintain exact same function signatures, add target param with default |
| Test updates miss edge cases | Medium | Run full test suite after each task, verify hash-based caching still works |
| Shared utilities scope creep | Low | Focus only on code needed for Lustre target, add more as needed for other targets |

## Open Questions

- [x] Terminology: "target" vs "backend" vs "output" → **Resolved: target**
- [x] File mapping: 1:1 or multiple outputs → **Resolved: 1:1 mapping**
- [x] Per-template override: @target() directive → **Resolved: No, CLI/config only**
- [x] Events in non-Lustre: error or warning → **Resolved: Compile error**

## References

- Current codegen: `src/ghtml/codegen.gleam`
- Current types: `src/ghtml/types.gleam`
- Lustre SSR docs: https://hexdocs.pm/lustre/guide/05-server-side-rendering.html
- Gleam StringTree: https://hexdocs.pm/gleam_stdlib/gleam/string_tree.html
