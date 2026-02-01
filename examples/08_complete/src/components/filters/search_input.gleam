// @generated from search_input.lustre
// @hash d6bff03a5fc7ebceb666d6ffa49d98a9b1223cf5ded7d9f14ecd314cfc2c4fb7
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text, element, none}
import lustre/element/html
import lustre/attribute
import lustre/event
import gleam/dynamic/decode

pub fn render(value: String, placeholder: String, on_change: decode.Decoder(msg), on_clear: fn() -> msg) -> Element(msg) {
  html.div([attribute.class("relative")], [element("sl-input", [attribute.value(value), attribute.placeholder(placeholder), event.on("sl-input", on_change)], [html.span([attribute.attribute("slot", "prefix")], [text("Search")])]), case value != "" { True -> html.button([attribute.class("absolute right-2 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"), event.on_click(on_clear())], [text("\n x\n ")]) False -> none() }])
}
