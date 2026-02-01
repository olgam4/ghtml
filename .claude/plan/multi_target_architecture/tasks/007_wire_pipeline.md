# Task 007: Wire Target Through Pipeline

## Description

Connect the CLI target flag through the generation pipeline so it reaches `codegen.generate()`.

## Dependencies

- Task 005 (codegen dispatcher implemented)
- Task 006 (CLI flag implemented)

## Success Criteria

1. Target flows from CLI → generate_all → codegen.generate
2. Default behavior unchanged (--target=lustre is implicit)
3. All existing tests pass

## Implementation Steps

### 1. Update generate_all signature

```gleam
/// Generate all templates in the given directory
pub fn generate_all(root: String, force: Bool, target: Target) -> GenerationStats {
  scanner.find_ghtml_files(root)
  |> list.fold(GenerationStats(0, 0, 0), fn(stats, source_path) {
    let output_path = scanner.to_output_path(source_path)

    case force || cache.needs_regeneration(source_path, output_path) {
      True -> {
        case process_file(source_path, output_path, target) {
          Ok(_) -> GenerationStats(..stats, generated: stats.generated + 1)
          Error(_) -> GenerationStats(..stats, errors: stats.errors + 1)
        }
      }
      False -> {
        io.println("· " <> source_path <> " (unchanged)")
        GenerationStats(..stats, skipped: stats.skipped + 1)
      }
    }
  })
}
```

### 2. Update process_file to accept target

```gleam
/// Process a single template file
fn process_file(
  source_path: String,
  output_path: String,
  target: Target,
) -> Result(Nil, String) {
  case simplifile.read(source_path) {
    Ok(content) -> {
      let hash = cache.hash_content(content)
      case parser.parse(content) {
        Ok(template) -> {
          let gleam_code = codegen.generate(template, source_path, hash, target)
          case simplifile.write(output_path, gleam_code) {
            Ok(_) -> {
              io.println("✓ " <> source_path <> " → " <> output_path)
              Ok(Nil)
            }
            Error(_) -> {
              io.println("✗ Error writing " <> output_path)
              Error("Write error")
            }
          }
        }
        Error(errors) -> {
          io.println("✗ Parse errors in " <> source_path <> ":")
          io.println(parser.format_errors(errors, content))
          Error("Parse error")
        }
      }
    }
    Error(_) -> {
      io.println("✗ Error reading " <> source_path)
      Error("Read error")
    }
  }
}
```

### 3. Update run_generate to pass target

```gleam
/// Run generation mode - scan and generate templates
fn run_generate(root: String, options: CliOptions) {
  io.println("ghtml v0.1.0")
  io.println("")

  let stats = generate_all(root, options.force, options.target)

  io.println("")
  io.println("Generated: " <> int.to_string(stats.generated))
  io.println("Skipped (unchanged): " <> int.to_string(stats.skipped))

  case stats.errors > 0 {
    True -> io.println("Errors: " <> int.to_string(stats.errors))
    False -> Nil
  }

  // Cleanup orphans
  let orphans = scanner.cleanup_orphans(root)
  case orphans > 0 {
    True -> io.println("Removed orphans: " <> int.to_string(orphans))
    False -> Nil
  }

  // Watch mode if requested
  case options.watch {
    True -> {
      io.println("")
      let _subject = watcher.start_watching(root, options.target)
      // Keep the process alive until interrupted
      process.sleep_forever()
    }
    False -> Nil
  }
}
```

### 4. Update watcher to accept and use target

In `watcher.gleam`:

```gleam
/// Internal state of the watcher actor
pub type WatcherState {
  WatcherState(
    root: String,
    file_mtimes: Dict(String, Int),
    self_subject: Option(Subject(WatcherMessage)),
    target: Target,  // Add this field
  )
}

/// Start the watcher actor for a given root directory.
pub fn start_watching(root: String, target: Target) -> Subject(WatcherMessage) {
  let initial_mtimes = get_all_mtimes(root)
  let initial_state =
    WatcherState(
      root: root,
      file_mtimes: initial_mtimes,
      self_subject: None,
      target: target,
    )
  // ... rest unchanged
}

/// Process a single template file, generating the corresponding Gleam code.
fn process_single_file(source_path: String, target: Target) {
  let output_path = scanner.to_output_path(source_path)

  case simplifile.read(source_path) {
    Ok(content) -> {
      let hash = cache.hash_content(content)
      case parser.parse(content) {
        Ok(template) -> {
          let gleam_code = codegen.generate(template, source_path, hash, target)
          // ... rest unchanged
        }
        // ... error handling unchanged
      }
    }
    // ... error handling unchanged
  }
}
```

Update the check_for_changes function to pass the target:

```gleam
fn check_for_changes(state: WatcherState) -> WatcherState {
  // ... existing logic ...

  case should_process {
    True -> process_single_file(path, state.target)
    False -> Nil
  }

  // ... rest unchanged
}
```

## Test Cases

Integration test that verifies end-to-end with explicit target:

```gleam
// test/integration/pipeline_test.gleam
pub fn generate_with_explicit_target_test() {
  // This test verifies the full pipeline works with explicit target
  let stats = ghtml.generate_all("test/fixtures/simple", False, types.Lustre)
  stats.errors |> should.equal(0)
}
```

## Verification Checklist

- [ ] Target flows through entire pipeline
- [ ] Watcher uses target
- [ ] `generate_all` accepts target parameter
- [ ] `process_file` accepts target parameter
- [ ] End-to-end test passes
- [ ] `just check` passes

## Notes

- This task connects all the pieces together
- The target parameter is threaded through all generation functions
- Watch mode needs the target to regenerate files correctly
- Default behavior is unchanged (Lustre target)

## Files to Modify

- `src/ghtml.gleam` - Update generate_all, run_generate, process_file
- `src/ghtml/watcher.gleam` - Add target to state, update start_watching, process_single_file
- `test/integration/pipeline_test.gleam` - Add target integration test
