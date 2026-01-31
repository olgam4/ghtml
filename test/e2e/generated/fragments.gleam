// @generated from multiple_roots.lustre
// @hash 8ad9b1d64ee51c26a3482758a3dbefd7118a55782971223730286b5b26909ae7
// DO NOT EDIT - regenerate with: just e2e-regen

import gleam/list
import lustre/attribute
import lustre/element.{type Element, fragment, text}
import lustre/element/html

/// Item type for keyed iteration - must have an id field
pub type Item {
  Item(id: String, content: String)
}

pub fn render(items: List(Item)) -> Element(msg) {
  fragment([
    html.header([attribute.class("header")], [text("Header Content")]),
    html.main([attribute.class("main")], [
      fragment(list.map(items, fn(item) { html.p([], [text(item.content)]) })),
    ]),
    html.footer([attribute.class("footer")], [text("Footer Content")]),
  ])
}
