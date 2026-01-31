# Lustre Template Generator - Development Commands
# Run `just` to see available commands
# Any unknown command falls through to gleam: `just add package` → `gleam add package`

# Default: show help
default:
    @just --list

# === Workflows ===

# Run all quality checks (build → test → integration → format → docs)
check:
    gleam build
    gleam test
    just integration
    gleam format
    gleam docs build
    @echo "✓ All checks passed"

# Simulate CI pipeline (matches .github/workflows/test.yml)
ci:
    gleam build
    gleam test
    just integration
    gleam format --check src test
    gleam docs build
    @echo "✓ CI simulation passed"

# === CLI Execution ===

# Run the CLI (default mode)
run:
    gleam run -m lustre_template_gen

# Run with force regeneration
run-force:
    gleam run -m lustre_template_gen -- force

# Run in watch mode
run-watch:
    gleam run -m lustre_template_gen -- watch

# Run orphan cleanup only
run-clean:
    gleam run -m lustre_template_gen -- clean

# === Utilities ===

# Clean build artifacts
clean:
    rm -rf build

# Run a specific test file (e.g., just test-file parser_tokenizer)
test-file name:
    gleam test -- --only {{name}}

# Run integration tests (TODO: implement in task 014)
# Creates test project, runs generator, verifies output compiles
integration:
    @echo "Integration tests not yet implemented (see task 014_integration_testing)"

# === Gleam Passthrough ===

# Pass any other command to gleam (e.g., just add package → gleam add package)
[positional-arguments]
@g *args:
    gleam {{args}}
