// @generated from app_shell.lustre
// @hash 2b839ff40c15a7ca4b5c8ebb8c851cca61aad52b1effaf8b011dcbe74a72a733
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, none}
import lustre/element/html
import lustre/attribute
import lustre/event

pub fn render(sidebar_open: Bool, on_toggle_sidebar: fn() -> msg) -> Element(msg) {
  html.div([attribute.class("min-h-screen bg-gray-50")], [case sidebar_open { True -> html.div([attribute.class("fixed inset-0 bg-black bg-opacity-50 z-30 lg:hidden"), event.on_click(on_toggle_sidebar())], []) False -> none() }])
}
