import components/checkbox_field
import components/form_field
import components/link_button
import lustre
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn main() {
  let app = lustre.element(view())
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn view() -> Element(msg) {
  html.div([], [
    html.h1([], [html.text("Attributes Example")]),
    // Static and Dynamic Attributes
    html.div([attribute.class("section")], [
      html.h2([], [html.text("Form Fields (Static + Dynamic Attributes)")]),
      form_field.render("Name", "John Doe", "Enter your name"),
      form_field.render("Email", "john@example.com", "Enter your email"),
    ]),
    // Boolean Attributes
    html.div([attribute.class("section")], [
      html.h2([], [html.text("Checkboxes (Boolean Attributes)")]),
      checkbox_field.render("Subscribe to newsletter", True),
      checkbox_field.render("Accept terms and conditions", False),
    ]),
    // Dynamic Attributes with Conditionals
    html.div([attribute.class("section")], [
      html.h2([], [html.text("Links (Conditional Attributes)")]),
      link_button.render("/about", "Internal Link", False),
      link_button.render("https://gleam.run", "Gleam Website", True),
      link_button.render("https://lustre.build", "Lustre Docs", True),
    ]),
  ])
}
