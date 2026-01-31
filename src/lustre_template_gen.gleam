//// Lustre Template Generator - CLI entry point.
////
//// A preprocessor that converts `.lustre` template files into Gleam modules
//// with Lustre `Element(msg)` render functions.
////
//// ## Usage
////
//// ```sh
//// gleam run -m lustre_template_gen              # Generate all
//// gleam run -m lustre_template_gen -- force     # Force regenerate
//// gleam run -m lustre_template_gen -- watch     # Watch mode
//// gleam run -m lustre_template_gen -- clean     # Remove orphans
//// ```

import gleam/io

/// Main entry point for the CLI
pub fn main() {
  io.println("lustre_template_gen v0.1.0")
}
