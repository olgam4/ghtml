# Design

## Overview

Editor support lives in `editors/` directory with each package independently publishable. The tree-sitter grammar serves as the foundation for modern editors, while TextMate grammar provides broader compatibility.

## Components

### tree-sitter-ghtml (`editors/tree-sitter-ghtml/`)
- Grammar definition in `grammar.js`
- Highlighting queries in `queries/highlights.scm`
- Published to npm as `tree-sitter-ghtml`

### zed-ghtml (`editors/zed-ghtml/`)
- Zed extension using tree-sitter grammar
- Configuration in `extension.toml`
- Published to Zed Extensions

### vscode-ghtml (`editors/vscode-ghtml/`)
- VS Code extension using TextMate grammar
- Grammar in `syntaxes/ghtml.tmLanguage.json`
- Published to VS Code Marketplace

## Data Flow

```
editors/
├── tree-sitter-ghtml/       # npm: tree-sitter-ghtml
│   ├── grammar.js            # Grammar definition
│   ├── package.json
│   ├── queries/
│   │   └── highlights.scm    # Highlighting queries
│   └── src/                   # Generated parser (gitignored)
│
├── vscode-ghtml/            # VS Code Marketplace
│   ├── package.json
│   ├── syntaxes/
│   │   └── ghtml.tmLanguage.json
│   └── language-configuration.json
│
└── zed-ghtml/               # Zed Extensions
    ├── extension.toml
    ├── languages/
    │   └── ghtml/
    │       └── config.toml
    └── grammars/             # Links to tree-sitter
```

## Interfaces

### Grammar Syntax Elements
- Directives: `@import`, `@params`
- HTML: tags, attributes, self-closing
- Expressions: `{...}` interpolation
- Control flow: `{#if}`, `{:else}`, `{/if}`, `{#each}`, `{#case}`
- Events: `@click={}`, `@input={}`
- Gleam types: in params block

## Decisions

| Decision | Rationale | Alternatives Considered |
|----------|-----------|------------------------|
| Tree-sitter first | Foundation for modern editors | TextMate first |
| Separate packages | Independent versioning/publishing | Monorepo package |
| No LSP initially | Complexity, can add later | Full LSP from start |
| TextMate for VS Code | Simpler than tree-sitter integration | VS Code tree-sitter plugin |

## Error Handling

### Invalid Syntax
- Tree-sitter produces error nodes
- Highlighting continues for valid portions
- TextMate may mis-highlight complex invalid syntax
