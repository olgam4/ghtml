// @generated from task_dialog.lustre
// @hash 4a6d57d9d89727e126d87348a743cdd0874b5f290d89e49a799d5a040a65ccdf
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text, element}
import lustre/element/html
import lustre/attribute
import lustre/event
import gleam/dynamic/decode
import gleam/option.{type Option, Some, None}
import model.{type Task, type FormState}

pub fn render(is_open: Bool, title: String, form: FormState, editing_task: Option(Task), on_title_change: decode.Decoder(msg), on_description_change: decode.Decoder(msg), on_priority_change: decode.Decoder(msg), on_due_date_change: decode.Decoder(msg), on_submit: fn() -> msg, on_cancel: fn() -> msg) -> Element(msg) {
  case is_open { True -> element("sl-dialog", [attribute.attribute("label", title), attribute.attribute("open", "")], [html.div([attribute.class("space-y-4")], [html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1")], [text("Title")]), element("sl-input", [attribute.value(form.title), attribute.placeholder("Task title"), event.on("sl-input", on_title_change)], [])]), html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1")], [text("Description")]), element("sl-textarea", [attribute.value(form.description), attribute.placeholder("Add details..."), attribute.attribute("rows", "3"), event.on("sl-input", on_description_change)], [])]), html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1")], [text("Priority")]), element("sl-select", [attribute.attribute("hoist", ""), event.on("sl-change", on_priority_change)], [element("sl-option", [attribute.value("none")], [text("No Priority")]), element("sl-option", [attribute.value("low")], [text("Low")]), element("sl-option", [attribute.value("medium")], [text("Medium")]), element("sl-option", [attribute.value("high")], [text("High")])])]), html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1")], [text("Due Date")]), case form.due_date { Some(date) -> element("sl-input", [attribute.type_("date"), attribute.value(date), event.on("sl-input", on_due_date_change)], []) None -> element("sl-input", [attribute.type_("date"), attribute.value(""), event.on("sl-input", on_due_date_change)], []) }])]), html.div([attribute.attribute("slot", "footer"), attribute.class("flex gap-2 justify-end")], [element("sl-button", [attribute.attribute("variant", "default"), event.on_click(on_cancel())], [text("Cancel")]), element("sl-button", [attribute.attribute("variant", "primary"), event.on_click(on_submit())], [case editing_task { Some(_) -> text("\n Update Task\n ") None -> text("\n Create Task\n ") }])])]) False -> html.span([], []) }
}
