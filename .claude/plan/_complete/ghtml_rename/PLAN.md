# Epic: Rename to ghtml

## Goal

Rename the project from `lustre_template_gen` with `.lustre` extension to `ghtml` with `.ghtml` extension. This better reflects the project's nature as a Gleam HTML template system that could target multiple backends (Lustre, SSR, static HTML) rather than being Lustre-specific.

## Background

The current naming (`.lustre` extension, `lustre_template_gen` package) ties the template format to Lustre specifically. However, the AST we generate is target-agnostic HTML with Gleam expressions. Renaming to `ghtml` (Gleam HTML):

- Accurately describes what the format is (HTML with Gleam)
- Follows precedent: `.phtml` (PHP), `.rhtml` (Ruby), `.eex` (Elixir)
- Allows future SSR/static HTML code generators without renaming
- Is shorter and easier to type

## Scope

### In Scope
- Rename file extension from `.lustre` to `.ghtml`
- Rename package from `lustre_template_gen` to `ghtml`
- Rename module paths from `lustre_template_gen/*` to `ghtml/*`
- Update CLI from `gleam run -m lustre_template_gen` to `gleam run -m ghtml`
- Rename all template files in fixtures and examples
- Update all documentation
- Update all build scripts (justfile)
- GitHub repository rename

### Out of Scope
- Hex.pm package publishing/deprecation
- Adding new features during rename
- Changing template syntax
- Adding SSR codegen (future work)

## Design Overview

The rename is a mechanical refactoring with no functional changes. The approach:

1. User renames GitHub repository first (manual step)
2. Update extension string literals in scanner/cache/codegen
3. Rename directory structure and gleam.toml
4. Update all imports (source and test)
5. Rename template files
6. Update tooling and documentation

```
Before:                          After:
src/lustre_template_gen.gleam    src/ghtml.gleam
src/lustre_template_gen/         src/ghtml/
  ├── cache.gleam                  ├── cache.gleam
  ├── codegen.gleam                ├── codegen.gleam
  ├── parser.gleam                 ├── parser.gleam
  ├── scanner.gleam                ├── scanner.gleam
  ├── types.gleam                  ├── types.gleam
  └── watcher.gleam                └── watcher.gleam

*.lustre files                   *.ghtml files
```

## Task Breakdown

| # | Task | Description | Dependencies |
|---|------|-------------|--------------|
| 001 | GitHub Rename | User manually renames GitHub repository | None |
| 002 | Extension References | Update `.lustre` → `.ghtml` in source | 001 |
| 003 | Module Structure | Rename directories and gleam.toml | 002 |
| 004 | Source Imports | Update all imports in src/ | 003 |
| 005 | Test Imports | Update all imports in test/ | 004 |
| 006 | Template Files | Rename all .lustre → .ghtml files | 005 |
| 007 | Justfile | Update build commands | 006 |
| 008 | Documentation | Update README, CLAUDE.md, CODEBASE.md | 007 |
| 009 | Assets | Update GIF scripts and regenerate | 008 |
| 010 | Verification | Run full test suite and examples | 009 |

## Task Dependency Graph

```
001_github_rename (USER ACTION)
         │
         v
002_extension_references
         │
         v
003_module_structure
         │
         v
004_source_imports
         │
         v
005_test_imports
         │
         v
006_template_files
         │
         v
007_justfile
         │
         v
008_documentation
         │
         v
009_assets
         │
         v
010_verification
```

## Success Criteria

1. `just check` passes with all tests green
2. `just examples` builds all examples successfully
3. All files use `.ghtml` extension
4. All imports reference `ghtml/` modules
5. CLI works with `gleam run -m ghtml`
6. No references to `lustre_template_gen` remain in code
7. Documentation reflects new naming

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Missing a reference | Medium | Grep for old names before/after each phase |
| Breaking tests | Medium | Run tests after each task |
| Git history confusion | Low | Clear commit messages per task |
| User confusion | Low | Clear PR description explaining rename |

## Open Questions

- [x] New name decided: `ghtml`
- [x] Extension decided: `.ghtml`

## References

- Discussion about naming in conversation history
- Precedent: `.phtml` (PHP), `.rhtml` (Ruby), `.eex` (Elixir)
