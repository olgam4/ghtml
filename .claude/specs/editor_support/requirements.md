# Requirements

Requirements use EARS (Easy Approach to Requirements Syntax).

## Patterns
- **Event-driven**: WHEN <trigger> THE <system> SHALL <response>
- **State-driven**: WHILE <condition> THE <system> SHALL <response>
- **Complex**: WHILE <condition> WHEN <trigger> THE <system> SHALL <response>

---

## REQ-001: Tree-sitter Grammar

WHEN a user opens a `.ghtml` file in an editor with tree-sitter support
THE tree-sitter grammar SHALL parse all valid ghtml syntax
AND provide an accurate AST for highlighting queries

**Acceptance Criteria:**
- [ ] Parses directives: `@import()`, `@params()`
- [ ] Parses HTML tags and attributes
- [ ] Parses expression interpolation: `{expression}`
- [ ] Parses control flow: `{#if}`, `{#each}`, `{#case}`
- [ ] Parses event handlers: `@click={}`
- [ ] All test fixtures parse correctly

---

## REQ-002: Zed Extension

WHEN a user installs the Zed extension
THE extension SHALL provide syntax highlighting for `.ghtml` files
AND use the tree-sitter grammar for accurate parsing

**Acceptance Criteria:**
- [ ] Extension loads in Zed
- [ ] Highlighting covers all syntax types
- [ ] Published to Zed Extensions marketplace

---

## REQ-003: TextMate Grammar

WHEN a user opens a `.ghtml` file in VS Code or TextMate-compatible editor
THE TextMate grammar SHALL provide syntax highlighting
AND handle most common syntax patterns correctly

**Acceptance Criteria:**
- [ ] Highlights directives, tags, expressions
- [ ] Handles nested structures reasonably
- [ ] Works with VS Code out of the box

---

## REQ-004: VS Code Extension

WHEN a user installs the VS Code extension
THE extension SHALL provide syntax highlighting for `.ghtml` files
AND register the file type association

**Acceptance Criteria:**
- [ ] Extension installs via marketplace
- [ ] `.ghtml` files auto-detected
- [ ] Syntax highlighting active

---

## REQ-005: Independent Publishing

THE editor packages SHALL be independently publishable
AND each package SHALL have its own versioning

**Acceptance Criteria:**
- [ ] tree-sitter-ghtml publishable to npm
- [ ] vscode-ghtml publishable to VS Code Marketplace
- [ ] zed-ghtml publishable to Zed Extensions
