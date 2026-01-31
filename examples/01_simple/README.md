# Example 01: Simple Template

## Concepts

This example introduces the basics of Lustre templates:
- `@params()` declaration for component parameters
- Static HTML attributes like `class="greeting"`
- Text interpolation with `{expression}`

## Prerequisites

None - start here!

## Features Demonstrated

### Template Parameters

```html
@params(name: String)
```

Parameters define what data your component accepts. They become function arguments in the generated Gleam code.

### Static Attributes

```html
<div class="greeting">
```

Standard HTML attributes are passed through as Lustre `attribute.class()` calls.

### Text Interpolation

```html
<h1>Hello, {name}!</h1>
```

Expressions in curly braces are interpolated. The expression must evaluate to `String`.

## Running the Example

1. Generate Gleam from templates:
   ```bash
   cd ../..  # Go to project root
   just run
   ```

2. Build and run:
   ```bash
   cd examples/01_simple
   gleam deps download
   gleam run -m lustre/dev start
   ```

3. Open http://localhost:1234 in your browser

## Key Files

- `src/components/greeting.lustre` - The template file
- `src/components/greeting.gleam` - Generated Gleam code (after running `just run`)
- `src/simple_example.gleam` - Main app that uses the component

## Exercises

1. Add a second parameter to the greeting component
2. Add another HTML element to the template
3. Try using a function call like `{string.uppercase(name)}`
