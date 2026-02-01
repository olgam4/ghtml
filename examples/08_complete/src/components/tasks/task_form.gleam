// @generated from task_form.lustre
// @hash b1a1ab91e616e8be715244da16df1d27db20c0742e3e653c4c313abfe0a2fa42
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text, element}
import lustre/element/html
import lustre/attribute
import lustre/event
import gleam/dynamic/decode
import gleam/option.{type Option, Some, None}
import model.{type Task, type Priority, priority_to_string}

pub fn render(task: Option(Task), title: String, description: String, priority: Priority, due_date: Option(String), on_title_change: decode.Decoder(msg), on_description_change: decode.Decoder(msg), on_priority_change: decode.Decoder(msg), on_due_date_change: decode.Decoder(msg), on_submit: fn() -> msg, on_cancel: fn() -> msg) -> Element(msg) {
  html.form([attribute.class("space-y-6")], [html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 mb-1")], [text("Title")]), element("sl-input", [attribute.value(title), attribute.placeholder("What needs to be done?"), event.on("sl-input", on_title_change), attribute.attribute("required", "")], [])]), html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 mb-1")], [text("Description")]), element("sl-textarea", [attribute.value(description), attribute.placeholder("Add more details..."), attribute.attribute("rows", "3"), event.on("sl-input", on_description_change)], [])]), html.div([attribute.class("grid grid-cols-1 sm:grid-cols-2 gap-4")], [html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 mb-1")], [text("Priority")]), element("sl-select", [attribute.value(priority_to_string(priority)), event.on("sl-change", on_priority_change)], [element("sl-option", [attribute.value("none")], [text("No Priority")]), element("sl-option", [attribute.value("low")], [text("Low")]), element("sl-option", [attribute.value("medium")], [text("Medium")]), element("sl-option", [attribute.value("high")], [text("High")])])]), html.div([], [html.label([attribute.class("block text-sm font-medium text-gray-700 mb-1")], [text("Due Date")]), case due_date { Some(date) -> element("sl-input", [attribute.type_("date"), attribute.value(date), event.on("sl-input", on_due_date_change)], []) None -> element("sl-input", [attribute.type_("date"), attribute.value(""), event.on("sl-input", on_due_date_change)], []) }])]), html.div([attribute.class("flex flex-col-reverse sm:flex-row sm:justify-end gap-3 pt-4 border-t border-gray-200")], [element("sl-button", [attribute.attribute("variant", "default"), event.on_click(on_cancel())], [text("Cancel")]), element("sl-button", [attribute.attribute("variant", "primary"), event.on_click(on_submit())], [case task { Some(_) -> text("\n Save Changes\n ") None -> text("\n Create Task\n ") }])])])
}
