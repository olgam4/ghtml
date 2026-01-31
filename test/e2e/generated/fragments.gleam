// @generated from multiple_roots.lustre
// @hash e05700cc9100828884ea219bc21611797a8ee945a2c8c5804cf52bb7fda7e545
// DO NOT EDIT - regenerate with: gleam run -m lustre_template_gen

import gleam/int
import gleam/list
import lustre/attribute
import lustre/element.{type Element, fragment, text}
import lustre/element/html
import lustre/element/keyed

pub fn render(items: List(String)) -> Element(msg) {
  fragment([
    html.header([attribute.class("header")], [text("Header Content")]),
    html.main([attribute.class("main")], [
      keyed.fragment(
        list.index_map(items, fn(item, i) {
          #(int.to_string(i), html.p([], [text(item)]))
        }),
      ),
    ]),
    html.footer([attribute.class("footer")], [text("Footer Content")]),
  ])
}
