# Lustre Template Generator - Development Commands
# Run `just` to see available commands
# Any unknown command falls through to gleam: `just add package` → `gleam add package`

# Default: show help
default:
    @just --list

# === Workflows ===

# Run all quality checks (build → unit → integration → format → docs)
check:
    gleam build
    just unit
    just integration
    gleam format
    gleam docs build
    @echo "✓ All checks passed"

# Simulate CI pipeline (matches .github/workflows/test.yml)
ci:
    gleam build
    just unit
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

# === Examples ===

# Build all examples (runs codegen and gleam build for each)
examples:
    #!/usr/bin/env bash
    set -euo pipefail
    for dir in examples/*/; do
        if [ -f "$dir/justfile" ]; then
            echo "Building example: $dir"
            (cd "$dir" && just build)
        fi
    done
    echo "✓ All examples built"

# Clean all examples (removes build artifacts and generated files)
examples-clean:
    #!/usr/bin/env bash
    set -euo pipefail
    for dir in examples/*/; do
        if [ -f "$dir/justfile" ]; then
            echo "Cleaning example: $dir"
            (cd "$dir" && just clean)
        fi
    done
    echo "✓ All examples cleaned"

# === Planning ===

# Create a new epic from template (e.g., just epic my_feature)
epic name:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -d ".plan/{{name}}" ]; then
        echo "Error: Epic '.plan/{{name}}' already exists"
        exit 1
    fi
    cp -r .plan/_template ".plan/{{name}}"
    echo "✓ Created epic: .plan/{{name}}/"
    echo "  - Edit .plan/{{name}}/PLAN.md with your epic details"
    echo "  - Create tasks from .plan/{{name}}/tasks/000_template_task.md"

# === Testing ===

# Run all unit tests (fast)
unit:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Running unit tests..."
    gleam build
    # Find all unit test modules and run them via EUnit
    MODULES=$(find test/unit -name "*_test.gleam" | sed 's|test/||' | sed 's|\.gleam$||' | sed 's|/|@|g' | tr '\n' ' ')
    erl -pa build/dev/erlang/*/ebin -noshell -eval "
        Modules = [list_to_atom(M) || M <- string:tokens(\"$MODULES\", \" \")],
        case eunit:test(Modules, [verbose]) of
            ok -> erlang:halt(0);
            _ -> erlang:halt(1)
        end.
    "
    echo "✓ Unit tests passed"

# Run Gleam integration tests
integration:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Running integration tests..."
    gleam build
    # Find all integration test modules and run them via EUnit
    MODULES=$(find test/integration -name "*_test.gleam" | sed 's|test/||' | sed 's|\.gleam$||' | sed 's|/|@|g' | tr '\n' ' ')
    erl -pa build/dev/erlang/*/ebin -noshell -eval "
        Modules = [list_to_atom(M) || M <- string:tokens(\"$MODULES\", \" \")],
        case eunit:test(Modules, [verbose]) of
            ok -> erlang:halt(0);
            _ -> erlang:halt(1)
        end.
    "
    echo "✓ Integration tests passed"

# Run CLI smoke test (uses .test/ directory)
integration-cli:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Running CLI integration test..."
    TEST_DIR=".test/cli_integration"
    rm -rf "$TEST_DIR"
    mkdir -p "$TEST_DIR/src"
    cat > "$TEST_DIR/gleam.toml" << 'EOF'
    name = "test_project"
    version = "0.1.0"
    target = "erlang"
    [dependencies]
    gleam_stdlib = ">= 0.34.0"
    EOF
    cat > "$TEST_DIR/src/test.lustre" << 'EOF'
    @params(name: String)
    <div class="greeting">{name}</div>
    EOF
    gleam run -m lustre_template_gen -- "$TEST_DIR"
    test -f "$TEST_DIR/src/test.gleam" || { echo "ERROR: test.gleam not generated"; exit 1; }
    grep -q "@generated" "$TEST_DIR/src/test.gleam" || { echo "ERROR: Missing @generated"; exit 1; }
    grep -q "pub fn render" "$TEST_DIR/src/test.gleam" || { echo "ERROR: Missing render"; exit 1; }
    echo "✓ CLI integration test passed"

# Run all tests
test: unit integration
    @echo "✓ All tests passed"

# === Utilities ===

# Clean build artifacts
clean:
    rm -rf build

# Run a specific test file (e.g., just test-file tokenizer)
test-file name:
    gleam test -- --only {{name}}

# === Gleam Passthrough ===

# Pass any other command to gleam (e.g., just add package → gleam add package)
[positional-arguments]
@g *args:
    gleam {{args}}
