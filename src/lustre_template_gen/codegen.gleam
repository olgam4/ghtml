//// Gleam code generator from parsed templates.
////
//// Transforms the parsed AST into valid Gleam source code that uses the
//// Lustre library to render HTML elements. Generated code is formatted
//// to be compliant with `gleam format`.

import gleam/list
import gleam/result
import gleam/string
import lustre_template_gen/cache
import lustre_template_gen/types.{
  type Attr, type Node, type Template, Element, ExprNode, TextNode,
}

/// List of HTML void elements that cannot have children
const void_elements = [
  "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta",
  "param", "source", "track", "wbr",
]

/// Generate Gleam code from a parsed template
pub fn generate(template: Template, source_path: String, hash: String) -> String {
  let filename = extract_filename(source_path)
  let header = cache.generate_header(filename, hash)
  let imports = generate_imports(template)
  let body = generate_function(template)

  header <> "\n" <> imports <> "\n\n" <> body <> "\n"
}

/// Extract the filename from a full path
fn extract_filename(path: String) -> String {
  path
  |> string.split("/")
  |> list.last()
  |> result.unwrap("unknown.lustre")
}

/// Generate import statements for the generated module
fn generate_imports(_template: Template) -> String {
  // For now, generate standard Lustre imports
  // TODO: In future tasks, customize based on template content
  "import lustre/element.{type Element, fragment, text}
import lustre/element/html"
}

/// Check if a tag is a custom element (contains a hyphen)
fn is_custom_element(tag: String) -> Bool {
  string.contains(tag, "-")
}

/// Check if a tag is a void element (no children allowed)
fn is_void_element(tag: String) -> Bool {
  list.contains(void_elements, tag)
}

/// Generate the main render function
fn generate_function(template: Template) -> String {
  let params = generate_params(template.params)

  case list.length(template.body) {
    0 -> "pub fn render(" <> params <> ") -> Element(msg) {\n  fragment([])\n}"
    1 -> {
      let body =
        generate_node_inline(
          list.first(template.body)
          |> result.unwrap(TextNode(
            "",
            types.point_span(types.start_position()),
          )),
        )
      "pub fn render(" <> params <> ") -> Element(msg) {\n  " <> body <> "\n}"
    }
    _ -> {
      // Multiple roots need fragment with multi-line formatting
      let children =
        template.body
        |> list.filter_map(fn(node) {
          let code = generate_node_inline(node)
          case string.trim(code) {
            "" -> Error(Nil)
            _ -> Ok("    " <> code)
          }
        })
        |> string.join(",\n")
      "pub fn render("
      <> params
      <> ") -> Element(msg) {\n  fragment([\n"
      <> children
      <> ",\n  ])\n}"
    }
  }
}

/// Generate function parameters from template params (single line, no trailing comma)
fn generate_params(params: List(#(String, String))) -> String {
  params
  |> list.map(fn(p) { p.0 <> ": " <> p.1 })
  |> string.join(", ")
}

/// Generate code for a single AST node (inline, no indentation)
fn generate_node_inline(node: Node) -> String {
  case node {
    Element(tag, attrs, children, _) ->
      generate_element_inline(tag, attrs, children)
    TextNode(content, _) -> generate_text_inline(content)
    ExprNode(expr, _) -> "text(" <> expr <> ")"
    // Control flow nodes handled in Task 009
    _ -> "fragment([])"
  }
}

/// Generate code for an HTML element (inline format)
fn generate_element_inline(
  tag: String,
  _attrs: List(Attr),
  children: List(Node),
) -> String {
  let attrs_code = "[]"
  // Placeholder, Task 008

  let children_code = case is_void_element(tag) {
    True -> ""
    False -> generate_children_inline(children)
  }

  case is_custom_element(tag) {
    True ->
      "element(\""
      <> tag
      <> "\", "
      <> attrs_code
      <> ", ["
      <> children_code
      <> "])"
    False ->
      "html." <> tag <> "(" <> attrs_code <> ", [" <> children_code <> "])"
  }
}

/// Generate code for a text node with whitespace normalization (inline)
fn generate_text_inline(content: String) -> String {
  let normalized = normalize_whitespace(content)
  case is_blank(normalized) {
    True -> ""
    False -> "text(\"" <> escape_string(normalized) <> "\")"
  }
}

/// Generate code for a list of children nodes (inline, comma-separated)
fn generate_children_inline(children: List(Node)) -> String {
  children
  |> list.filter_map(fn(child) {
    let code = generate_node_inline(child)
    case string.trim(code) {
      "" -> Error(Nil)
      _ -> Ok(code)
    }
  })
  |> string.join(", ")
}

/// Escape special characters in a string for Gleam code
fn escape_string(s: String) -> String {
  s
  |> string.replace("\\", "\\\\")
  |> string.replace("\"", "\\\"")
  |> string.replace("\n", "\\n")
  |> string.replace("\r", "\\r")
  |> string.replace("\t", "\\t")
}

/// Normalize whitespace by collapsing multiple spaces/tabs to single spaces
/// Newlines are preserved (they will be escaped later)
fn normalize_whitespace(text: String) -> String {
  text
  |> string.to_graphemes()
  |> collapse_spaces(False, [])
  |> list.reverse()
  |> string.concat()
}

/// Helper function to collapse consecutive spaces/tabs (not newlines)
fn collapse_spaces(
  chars: List(String),
  saw_space: Bool,
  acc: List(String),
) -> List(String) {
  case chars {
    [] -> acc
    [c, ..rest] -> {
      case c {
        // Spaces and tabs get collapsed
        " " | "\t" ->
          case saw_space {
            True -> collapse_spaces(rest, True, acc)
            False -> collapse_spaces(rest, True, [" ", ..acc])
          }
        // Newlines and carriage returns are preserved (will be escaped later)
        "\n" | "\r" -> collapse_spaces(rest, False, [c, ..acc])
        // Regular characters reset the space tracking
        _ -> collapse_spaces(rest, False, [c, ..acc])
      }
    }
  }
}

/// Check if a string is blank (empty or only whitespace)
fn is_blank(text: String) -> Bool {
  string.trim(text) == ""
}
