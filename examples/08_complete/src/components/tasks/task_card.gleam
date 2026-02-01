// @generated from task_card.lustre
// @hash ac16cf26f5b9dd024b7393896b279870923df8795fd6c9dc133b9c505022f4a0
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text, none}
import lustre/element/html
import lustre/attribute
import lustre/event
import gleam/int
import gleam/list
import gleam/option.{Some, None}
import model.{type Task, Todo, InProgress, Done, High, Medium, Low, NoPriority, completed_subtasks}

pub fn render(task: Task, on_toggle_status: fn() -> msg, on_click: fn() -> msg) -> Element(msg) {
  html.article([attribute.class("group bg-white dark:bg-gray-800 rounded-lg border border-gray-200 dark:border-gray-700 p-4 hover:shadow-md transition-shadow cursor-pointer"), event.on_click(on_click())], [html.div([attribute.class("flex items-start gap-3")], [html.button([attribute.class("mt-0.5 flex-shrink-0"), event.on_click(on_toggle_status())], [case task.status { Done -> html.span([attribute.class("w-5 h-5 rounded-full bg-green-500 flex items-center justify-center text-white text-xs")], [text("Y")]) InProgress -> html.span([attribute.class("w-5 h-5 rounded-full border-2 border-blue-500 flex items-center justify-center")], [html.span([attribute.class("w-2 h-2 rounded-full bg-blue-500")], [])]) Todo -> html.span([attribute.class("w-5 h-5 rounded-full border-2 border-gray-300 dark:border-gray-500 group-hover:border-gray-400 dark:group-hover:border-gray-300")], []) }]), html.div([attribute.class("flex-1 min-w-0")], [html.h3([attribute.class("font-medium text-gray-900 dark:text-white truncate")], [case task.status == Done { True -> html.span([attribute.class("line-through text-gray-500 dark:text-gray-400")], [text(task.title)]) False -> text(task.title) }]), case task.description != "" { True -> html.p([attribute.class("mt-1 text-sm text-gray-500 dark:text-gray-400 line-clamp-2")], [text(task.description)]) False -> none() }, html.div([attribute.class("mt-2 flex items-center gap-2 flex-wrap")], [case task.priority { High -> html.span([attribute.class("inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-red-100 dark:bg-red-900 text-red-800 dark:text-red-200")], [text("\n High\n ")]) Medium -> html.span([attribute.class("inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-yellow-100 dark:bg-yellow-900 text-yellow-800 dark:text-yellow-200")], [text("\n Medium\n ")]) Low -> html.span([attribute.class("inline-flex items-center px-2 py-0.5 rounded text-xs font-medium bg-blue-100 dark:bg-blue-900 text-blue-800 dark:text-blue-200")], [text("\n Low\n ")]) NoPriority -> html.span([], []) }, case task.due_date { Some(date) -> html.span([attribute.class("inline-flex items-center text-xs text-gray-500 dark:text-gray-400")], [text("\n Due: "), text(date)]) None -> html.span([], []) }, case task.subtasks != [] { True -> html.span([attribute.class("inline-flex items-center text-xs text-gray-500 dark:text-gray-400")], [text("\n Subtasks: "), text(int.to_string(completed_subtasks(task))), text("/"), text(int.to_string(list.length(task.subtasks)))]) False -> none() }])])])])
}
