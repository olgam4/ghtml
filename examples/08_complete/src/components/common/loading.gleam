// @generated from loading.lustre
// @hash f2c8cc3f5229f0ccc15327fd76ed6b4a250db392431a77923636bcc4789bfc75
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text, element, none}
import lustre/element/html
import lustre/attribute

pub fn render(message: String) -> Element(msg) {
  html.div([attribute.class("flex flex-col items-center justify-center py-12")], [element("sl-spinner", [attribute.class("text-5xl")], []), case message != "" { True -> html.p([attribute.class("mt-4 text-gray-600")], [text(message)]) False -> none() }])
}
