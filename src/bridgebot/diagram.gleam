import bridgebot/card.{type Card}
import bridgebot/layout.{type Layout}
import bridgebot/scoring.{type Scoring}
import bridgebot/vul.{type Vul}
import gleam/option.{type Option}

pub type Diagram {
  Diagram(
    layout: Layout,
    lead: Option(Card),
    vul: Option(Vul),
    scoring: Option(Scoring),
  )
}
