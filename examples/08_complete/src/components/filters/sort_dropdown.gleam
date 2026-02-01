// @generated from sort_dropdown.lustre
// @hash 6300a07bd69459fbef2571391217c4acf2ede4eac902dfcffabb20bd417913c1
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import lustre/element.{type Element, text, element}
import lustre/attribute
import lustre/event
import model.{type SortBy, SortByCreated, SortByDueDate, SortByPriority, SortByTitle}

pub fn render(current_sort: SortBy, on_change: fn(SortBy) -> msg) -> Element(msg) {
  element("sl-dropdown", [], [element("sl-button", [attribute.attribute("slot", "trigger"), attribute.attribute("caret", "")], [case current_sort { SortByCreated -> text("\n Sort: Created\n ") SortByDueDate -> text("\n Sort: Due Date\n ") SortByPriority -> text("\n Sort: Priority\n ") SortByTitle -> text("\n Sort: Title\n ") }]), element("sl-menu", [], [element("sl-menu-item", [event.on_click(on_change(SortByCreated))], [text("Created")]), element("sl-menu-item", [event.on_click(on_change(SortByDueDate))], [text("Due Date")]), element("sl-menu-item", [event.on_click(on_change(SortByPriority))], [text("Priority")]), element("sl-menu-item", [event.on_click(on_change(SortByTitle))], [text("Title")])])])
}
