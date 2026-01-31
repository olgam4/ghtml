# Simple Lustre Example

A basic example showing how to use `lustre_template_gen` with a Lustre application.

## Prerequisites

- [Gleam](https://gleam.run/) installed
- [just](https://github.com/casey/just) command runner

## Project Structure

```
simple/
├── src/
│   ├── app.gleam              # Main Lustre application
│   └── components/
│       ├── greeting.lustre    # Template source
│       └── greeting.gleam     # Generated (do not edit)
├── gleam.toml
├── justfile
└── index.html
```

## Usage

```sh
# See available commands
just

# Build (runs codegen + gleam build)
just build

# Start dev server with hot reload
just dev

# Run codegen only
just codegen

# Watch mode (regenerates on file changes)
just codegen-watch

# Clean generated files
just clean
```

## How It Works

1. Write templates in `.lustre` files using HTML-like syntax with Gleam expressions
2. Run `just codegen` to generate `.gleam` modules with `render()` functions
3. Import and use the generated modules in your Lustre application

## Template Syntax

```html
@params(
  name: String,
)

<div class="greeting">
  <h1>Hello, {name}!</h1>
</div>
```

Generates:

```gleam
pub fn render(name: String) -> Element(msg) {
  html.div([attribute.class("greeting")], [
    html.h1([], [text("Hello, "), text(name), text("!")])
  ])
}
```
