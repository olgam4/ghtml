// @generated from button.lustre
// @hash 3a1360dbc383090b212e6534610e76d3feaea39f727f3c667f0231bbe170e79b
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute
import lustre/event

pub fn render(label: String, variant: String, on_click: fn() -> msg) -> Element(msg) {
  case variant == "primary" { True -> html.button([attribute.class("px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors"), event.on_click(on_click())], [text(label)]) False -> case variant == "danger" { True -> html.button([attribute.class("px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 transition-colors"), event.on_click(on_click())], [text(label)]) False -> html.button([attribute.class("px-4 py-2 bg-gray-100 text-gray-700 rounded-md hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 transition-colors"), event.on_click(on_click())], [text(label)]) } }
}
