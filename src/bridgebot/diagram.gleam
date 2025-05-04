import bridgebot/card.{type Card}
import bridgebot/details.{type Details}
import bridgebot/layout.{type Layout}
import gleam/option.{type Option}

pub type Diagram {
  Diagram(layout: Layout, lead: Option(Card), details: Details)
}
