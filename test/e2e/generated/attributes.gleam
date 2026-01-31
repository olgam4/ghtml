// @generated from all_attrs.lustre
// @hash e26ab58abaec81b9eb679694a3d1c024cbfe887862dba0295fde2e079a22c42c
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/attribute
import lustre/element.{type Element, text}
import lustre/element/html
import lustre/event

pub fn render(
  value: String,
  is_disabled: Bool,
  on_change: fn(String) -> msg,
  on_click: fn() -> msg,
) -> Element(msg) {
  html.form([attribute.class("form")], [
    html.input([
      attribute.type_("text"),
      attribute.class("input"),
      attribute.value(value),
      attribute.disabled(True),
      event.on_input(on_change),
    ]),
    html.button([attribute.type_("submit"), event.on_click(on_click())], [
      text("\n Submit\n "),
    ]),
  ])
}
