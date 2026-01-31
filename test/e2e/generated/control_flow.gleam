// @generated from full.lustre
// @hash ece58a0a04819b7cc94bbbd78092143d6ddf5e4821a3e19bef0cb7228ca86101
// DO NOT EDIT - regenerate with: just e2e-regen

import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element, fragment, text}
import lustre/element/html

/// Type alias for User - in real usage this would come from app/types
pub type User {
  User(name: String, is_admin: Bool)
}

/// Type alias for Status - in real usage this would come from app/types
pub type Status {
  Active
  Inactive
}

pub fn render(user: User, items: List(String), status: Status) -> Element(msg) {
  html.article([attribute.class("user-card")], [
    case user.is_admin {
      True -> html.span([attribute.class("badge")], [text("Admin")])
      False -> html.span([attribute.class("badge")], [text("User")])
    },
    html.ul([], [
      fragment(
        list.index_map(items, fn(item, i) {
          html.li([], [
            text(int.to_string(i)),
            text(": "),
            text(item),
          ])
        }),
      ),
    ]),
    case status {
      Active -> html.span([attribute.class("status active")], [text("Active")])
      Inactive ->
        html.span([attribute.class("status inactive")], [text("Inactive")])
    },
  ])
}
