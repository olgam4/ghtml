# Task 004: TextMate Grammar

## Description

Create a TextMate grammar (`.tmLanguage.json`) for `.ghtml` files. TextMate grammars are widely supported by VS Code, Sublime Text, Atom, and many other editors, providing broad compatibility for syntax highlighting.

## Dependencies

- 001_directory_structure - Directory structure must be set up first

## Success Criteria

1. TextMate grammar is valid JSON
2. All major syntax elements are highlighted correctly
3. Grammar handles nested constructs (expressions inside attributes)
4. Works correctly in VS Code's grammar preview
5. Covers same syntax elements as tree-sitter grammar

## Implementation Steps

### 1. Create TextMate Grammar Structure

`syntaxes/ghtml.tmLanguage.json`:

```json
{
  "$schema": "https://raw.githubusercontent.com/martinring/tmlanguage/master/tmlanguage.json",
  "name": "Lustre",
  "scopeName": "source.ghtml",
  "fileTypes": ["lustre"],
  "patterns": [
    { "include": "#directive" },
    { "include": "#control-flow" },
    { "include": "#element" },
    { "include": "#expression" }
  ],
  "repository": {
    // ... pattern definitions
  }
}
```

### 2. Define Directive Patterns

```json
"directive": {
  "name": "meta.directive.ghtml",
  "begin": "(@)(import|params)\\s*(\\()",
  "beginCaptures": {
    "1": { "name": "punctuation.definition.directive.ghtml" },
    "2": { "name": "keyword.control.directive.ghtml" },
    "3": { "name": "punctuation.section.directive.begin.ghtml" }
  },
  "end": "\\)",
  "endCaptures": {
    "0": { "name": "punctuation.section.directive.end.ghtml" }
  },
  "patterns": [
    { "include": "#directive-content" }
  ]
}
```

### 3. Define Control Flow Patterns

```json
"if-block": {
  "name": "meta.control.if.ghtml",
  "begin": "(\\{)(#if)\\b",
  "beginCaptures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "keyword.control.conditional.ghtml" }
  },
  "end": "(\\{)(/if)(\\})",
  "endCaptures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "keyword.control.conditional.ghtml" },
    "3": { "name": "punctuation.section.block.end.ghtml" }
  },
  "patterns": [
    { "include": "#else-clause" },
    { "include": "$self" }
  ]
},

"else-clause": {
  "match": "(\\{)(:else)(\\})",
  "captures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "keyword.control.conditional.ghtml" },
    "3": { "name": "punctuation.section.block.end.ghtml" }
  }
},

"each-block": {
  "name": "meta.control.each.ghtml",
  "begin": "(\\{)(#each)\\s+",
  "beginCaptures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "keyword.control.loop.ghtml" }
  },
  "end": "(\\})",
  "endCaptures": {
    "1": { "name": "punctuation.section.block.end.ghtml" }
  },
  "patterns": [
    {
      "match": "\\b(as)\\b",
      "name": "keyword.control.as.ghtml"
    },
    { "include": "#gleam-expression" }
  ]
},

"case-block": {
  "name": "meta.control.case.ghtml",
  "begin": "(\\{)(#case)\\b",
  "beginCaptures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "keyword.control.switch.ghtml" }
  },
  "end": "(\\{)(/case)(\\})",
  "endCaptures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "keyword.control.switch.ghtml" },
    "3": { "name": "punctuation.section.block.end.ghtml" }
  },
  "patterns": [
    { "include": "#case-pattern" },
    { "include": "$self" }
  ]
},

"case-pattern": {
  "match": "(\\{)(:)([A-Z][a-zA-Z0-9_]*)(\\})",
  "captures": {
    "1": { "name": "punctuation.section.block.begin.ghtml" },
    "2": { "name": "punctuation.separator.ghtml" },
    "3": { "name": "entity.name.tag.constructor.ghtml" },
    "4": { "name": "punctuation.section.block.end.ghtml" }
  }
}
```

### 4. Define HTML Element Patterns

```json
"element": {
  "patterns": [
    { "include": "#self-closing-tag" },
    { "include": "#open-tag" },
    { "include": "#close-tag" }
  ]
},

"open-tag": {
  "name": "meta.tag.ghtml",
  "begin": "(<)([a-zA-Z][a-zA-Z0-9-]*)",
  "beginCaptures": {
    "1": { "name": "punctuation.definition.tag.begin.ghtml" },
    "2": { "name": "entity.name.tag.ghtml" }
  },
  "end": "(>)",
  "endCaptures": {
    "1": { "name": "punctuation.definition.tag.end.ghtml" }
  },
  "patterns": [
    { "include": "#attribute" }
  ]
},

"close-tag": {
  "match": "(</)([a-zA-Z][a-zA-Z0-9-]*)(>)",
  "captures": {
    "1": { "name": "punctuation.definition.tag.begin.ghtml" },
    "2": { "name": "entity.name.tag.ghtml" },
    "3": { "name": "punctuation.definition.tag.end.ghtml" }
  }
},

"self-closing-tag": {
  "name": "meta.tag.self-closing.ghtml",
  "begin": "(<)([a-zA-Z][a-zA-Z0-9-]*)",
  "beginCaptures": {
    "1": { "name": "punctuation.definition.tag.begin.ghtml" },
    "2": { "name": "entity.name.tag.ghtml" }
  },
  "end": "(/>)",
  "endCaptures": {
    "1": { "name": "punctuation.definition.tag.end.ghtml" }
  },
  "patterns": [
    { "include": "#attribute" }
  ]
}
```

### 5. Define Attribute Patterns

```json
"attribute": {
  "patterns": [
    { "include": "#event-handler" },
    { "include": "#dynamic-attribute" },
    { "include": "#static-attribute" },
    { "include": "#boolean-attribute" }
  ]
},

"event-handler": {
  "begin": "(@)([a-z][a-zA-Z0-9]*)(=)(\\{)",
  "beginCaptures": {
    "1": { "name": "punctuation.definition.event.ghtml" },
    "2": { "name": "entity.other.attribute-name.event.ghtml" },
    "3": { "name": "punctuation.separator.key-value.ghtml" },
    "4": { "name": "punctuation.section.embedded.begin.ghtml" }
  },
  "end": "(\\})",
  "endCaptures": {
    "1": { "name": "punctuation.section.embedded.end.ghtml" }
  },
  "patterns": [
    { "include": "#gleam-expression" }
  ]
},

"dynamic-attribute": {
  "begin": "([a-zA-Z][a-zA-Z0-9-]*)(=)(\\{)",
  "beginCaptures": {
    "1": { "name": "entity.other.attribute-name.ghtml" },
    "2": { "name": "punctuation.separator.key-value.ghtml" },
    "3": { "name": "punctuation.section.embedded.begin.ghtml" }
  },
  "end": "(\\})",
  "endCaptures": {
    "1": { "name": "punctuation.section.embedded.end.ghtml" }
  },
  "patterns": [
    { "include": "#gleam-expression" }
  ]
},

"static-attribute": {
  "match": "([a-zA-Z][a-zA-Z0-9-]*)(=)(\"[^\"]*\")",
  "captures": {
    "1": { "name": "entity.other.attribute-name.ghtml" },
    "2": { "name": "punctuation.separator.key-value.ghtml" },
    "3": { "name": "string.quoted.double.ghtml" }
  }
},

"boolean-attribute": {
  "match": "\\b([a-zA-Z][a-zA-Z0-9-]*)\\b(?!=)",
  "name": "entity.other.attribute-name.ghtml"
}
```

### 6. Define Expression Patterns

```json
"expression": {
  "name": "meta.embedded.expression.ghtml",
  "begin": "(\\{)(?![#/:])",
  "beginCaptures": {
    "1": { "name": "punctuation.section.embedded.begin.ghtml" }
  },
  "end": "(\\})",
  "endCaptures": {
    "1": { "name": "punctuation.section.embedded.end.ghtml" }
  },
  "patterns": [
    { "include": "#gleam-expression" }
  ]
},

"gleam-expression": {
  "patterns": [
    {
      "match": "\\b([A-Z][a-zA-Z0-9_]*)\\b",
      "name": "entity.name.type.ghtml"
    },
    {
      "match": "\\b([a-z_][a-zA-Z0-9_]*)\\s*(?=\\()",
      "name": "entity.name.function.ghtml"
    },
    {
      "match": "\\b([a-z_][a-zA-Z0-9_]*)\\b",
      "name": "variable.other.ghtml"
    },
    {
      "match": "\\.",
      "name": "punctuation.accessor.ghtml"
    },
    {
      "match": ",",
      "name": "punctuation.separator.ghtml"
    }
  ]
}
```

## Test Cases

Test the grammar with VS Code's "Developer: Inspect Editor Tokens and Scopes" command:

1. `@import(gleam/int)` - directive highlighted
2. `<div class="test">` - tag and attribute highlighted
3. `{name}` - expression brackets and variable highlighted
4. `{#if condition}` - control keyword highlighted
5. `@click={handler}` - event handler highlighted
6. `{:Active}` - case pattern/constructor highlighted

## Verification Checklist

- [ ] JSON is valid (no syntax errors)
- [ ] VS Code recognizes `.ghtml` files
- [ ] Directives are highlighted correctly
- [ ] HTML tags are highlighted correctly
- [ ] Attributes (static, dynamic, boolean) are highlighted
- [ ] Expressions `{...}` are highlighted
- [ ] Control flow blocks are highlighted
- [ ] Event handlers are highlighted
- [ ] Nested constructs work (expression inside attribute)
- [ ] No "invalid" or broken highlighting in test fixtures

## Notes

- TextMate grammars use regex, which has limitations for nested structures
- Use `begin`/`end` for block constructs that need nesting
- The `$self` reference allows recursive matching
- Scope names follow conventions: `keyword.control`, `entity.name.tag`, etc.
- Test with "Developer: Inspect Editor Tokens and Scopes" in VS Code

## Files to Modify

- `editors/vscode-ghtml/syntaxes/ghtml.tmLanguage.json` - Complete grammar

## References

- [TextMate Language Grammars](https://macromates.com/manual/en/language_grammars)
- [VS Code Syntax Highlight Guide](https://code.visualstudio.com/api/language-extensions/syntax-highlight-guide)
- [Naming Conventions](https://www.sublimetext.com/docs/scope_naming.html)
- [Svelte TextMate Grammar](https://github.com/sveltejs/language-tools/tree/master/packages/svelte-vscode/syntaxes)
