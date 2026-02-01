// @generated from badge.lustre
// @hash f39322ad5278a1286909061b7c8c6e59a68f3336a3f0a82eefe5b81074439ddd
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute

pub fn render(label: String, variant: String) -> Element(msg) {
  case variant == "success" { True -> html.span([attribute.class("inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800")], [text(label)]) False -> case variant == "warning" { True -> html.span([attribute.class("inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800")], [text(label)]) False -> case variant == "danger" { True -> html.span([attribute.class("inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800")], [text(label)]) False -> case variant == "info" { True -> html.span([attribute.class("inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800")], [text(label)]) False -> html.span([attribute.class("inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800")], [text(label)]) } } } }
}
