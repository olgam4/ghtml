# Requirements

Requirements use EARS (Easy Approach to Requirements Syntax).

## Patterns
- **Event-driven**: WHEN <trigger> THE <system> SHALL <response>
- **State-driven**: WHILE <condition> THE <system> SHALL <response>
- **Complex**: WHILE <condition> WHEN <trigger> THE <system> SHALL <response>

---

## REQ-001: Target Directory Structure

WHEN the project is compiled
THE system SHALL have a `src/ghtml/target/` directory
AND contain target-specific codegen modules

**Acceptance Criteria:**
- [ ] `src/ghtml/target/` directory exists
- [ ] `target/lustre.gleam` contains Lustre-specific code
- [ ] Structure supports adding new targets

---

## REQ-002: Target Type Definition

WHEN a target is specified
THE system SHALL use a `Target` type to represent it
AND the type SHALL support future variants

**Acceptance Criteria:**
- [ ] `Target` type defined in `types.gleam`
- [ ] `Lustre` variant exists
- [ ] Type is extensible for future targets

---

## REQ-003: Shared Utilities Extraction

WHEN generating code for any target
THE system SHALL use shared utilities for common operations
AND utilities SHALL be target-agnostic

**Acceptance Criteria:**
- [ ] Common helpers extracted to shared module
- [ ] No Lustre-specific code in shared utilities
- [ ] All targets can use shared code

---

## REQ-004: Lustre Target Module

WHEN generating Lustre output
THE system SHALL use `target/lustre.gleam`
AND produce identical output to the current implementation

**Acceptance Criteria:**
- [ ] All Lustre-specific code in `target/lustre.gleam`
- [ ] Output matches current implementation exactly
- [ ] All existing tests pass

---

## REQ-005: Codegen Dispatcher

WHEN `codegen.generate()` is called
THE dispatcher SHALL route to the appropriate target module
AND return target-specific output

**Acceptance Criteria:**
- [ ] `codegen.gleam` dispatches by target
- [ ] Thin dispatcher layer (no codegen logic)
- [ ] Easy to add new targets

---

## REQ-006: CLI Target Flag

WHEN user runs `gleam run -m ghtml -- --target=<name>`
THE CLI SHALL pass the target to the codegen pipeline
AND default to `lustre` if not specified

**Acceptance Criteria:**
- [ ] `--target` flag parsed by CLI
- [ ] Default value is `lustre`
- [ ] Invalid targets produce error message

---

## REQ-007: Pipeline Integration

WHEN the generation pipeline runs
THE target selection SHALL flow from CLI to codegen
AND all generated files SHALL use the same target

**Acceptance Criteria:**
- [ ] Target flows through entire pipeline
- [ ] Consistent output for all templates
- [ ] No mixed-target output
