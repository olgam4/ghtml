// @generated from subtask_item.lustre
// @hash 3934668db545d9e0684be858eaee5f95d530f3a87e0449e89d74edbeee011629
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text}
import lustre/element/html
import lustre/attribute
import lustre/event
import model.{type Subtask}

pub fn render(subtask: Subtask, on_toggle: fn() -> msg, on_delete: fn() -> msg) -> Element(msg) {
  html.div([attribute.class("flex items-center gap-2 py-1 group")], [html.input([attribute.type_("checkbox"), attribute.checked(subtask.completed), attribute.class("rounded border-gray-300"), event.on_click(on_toggle())]), case subtask.completed { True -> html.span([attribute.class("flex-1 text-gray-500 line-through")], [text(subtask.text)]) False -> html.span([attribute.class("flex-1 text-gray-700")], [text(subtask.text)]) }, html.button([attribute.class("opacity-0 group-hover:opacity-100 text-gray-400 hover:text-red-500 transition-opacity"), event.on_click(on_delete())], [text("\n x\n ")])])
}
