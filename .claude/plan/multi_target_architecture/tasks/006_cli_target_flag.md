# Task 006: Add CLI --target Flag

## Description

Add `--target=<target>` flag to the CLI. Default is `lustre`.

## Dependencies

- Task 002 (Target type defined)

## Success Criteria

1. `--target=lustre` is recognized
2. No `--target` flag defaults to `lustre`
3. Invalid target produces helpful error
4. Help text documents the flag (in module doc)

## Implementation Steps

### 1. Update CliOptions type

In `ghtml.gleam`, update the options type:

```gleam
import ghtml/types.{type Target, Lustre}

/// CLI options parsed from command-line arguments
pub type CliOptions {
  CliOptions(
    force: Bool,
    clean_only: Bool,
    watch: Bool,
    root: String,
    target: Target,  // Add this field
  )
}
```

### 2. Update parse_options function

```gleam
/// Parse command-line arguments into options
pub fn parse_options(args: List(String)) -> CliOptions {
  let #(target, remaining_args) = extract_target(args)

  // Extract root directory from remaining args (first non-flag argument, or ".")
  let root =
    remaining_args
    |> list.find(fn(arg) {
      !list.contains(["force", "clean", "watch"], arg)
      && !string.starts_with(arg, "--")
    })
    |> result.unwrap(".")

  CliOptions(
    force: list.contains(remaining_args, "force"),
    clean_only: list.contains(remaining_args, "clean"),
    watch: list.contains(remaining_args, "watch"),
    root: root,
    target: target,
  )
}

/// Extract target from arguments, returning the target and remaining args
fn extract_target(args: List(String)) -> #(Target, List(String)) {
  let #(target_args, other_args) = list.partition(args, fn(arg) {
    string.starts_with(arg, "--target")
  })

  let target = case target_args {
    [] -> Lustre  // Default
    ["--target=lustre", ..] -> Lustre
    ["--target=" <> unknown, ..] -> {
      io.println_error("Unknown target: " <> unknown)
      io.println_error("Available targets: lustre")
      erlang.halt(1)
      Lustre  // Unreachable but needed for type
    }
    _ -> Lustre
  }

  #(target, other_args)
}
```

### 3. Update module documentation

Update the module doc at the top of `ghtml.gleam`:

```gleam
//// ghtml - Gleam HTML Template Generator.
////
//// A preprocessor that converts `.ghtml` template files into Gleam modules
//// with render functions.
////
//// ## Usage
////
//// ```sh
//// gleam run -m ghtml                      # Generate all (default: lustre target)
//// gleam run -m ghtml -- --target=lustre   # Explicit lustre target
//// gleam run -m ghtml -- force             # Force regenerate
//// gleam run -m ghtml -- watch             # Watch mode
//// gleam run -m ghtml -- clean             # Remove orphans
//// ```
////
//// ## Targets
////
//// - `lustre` (default): Generates Lustre Element(msg) render functions
```

## Test Cases

```gleam
// test/unit/cli_test.gleam
pub fn parse_target_flag_lustre_test() {
  let opts = ghtml.parse_options(["--target=lustre"])
  opts.target |> should.equal(types.Lustre)
}

pub fn parse_default_target_test() {
  let opts = ghtml.parse_options([])
  opts.target |> should.equal(types.Lustre)
}

pub fn parse_target_with_other_flags_test() {
  let opts = ghtml.parse_options(["--target=lustre", "force", "watch"])
  opts.target |> should.equal(types.Lustre)
  opts.force |> should.equal(True)
  opts.watch |> should.equal(True)
}

pub fn parse_target_with_root_test() {
  let opts = ghtml.parse_options(["--target=lustre", "./my-project"])
  opts.target |> should.equal(types.Lustre)
  opts.root |> should.equal("./my-project")
}
```

## Verification Checklist

- [ ] `--target=lustre` parses correctly
- [ ] Default target is Lustre
- [ ] Invalid target shows error and exits
- [ ] Tests added and pass
- [ ] `gleam run -m ghtml -- --target=lustre` works

## Notes

- Use `gleam/erlang.halt(1)` for error exit
- The `--target=` format matches common CLI conventions
- Future targets will just need to add new cases to extract_target

## Files to Modify

- `src/ghtml.gleam` - Add target to CliOptions, update parse_options
- `test/unit/cli_test.gleam` - Add target flag tests
