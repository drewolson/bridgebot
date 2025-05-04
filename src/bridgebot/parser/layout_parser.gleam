import bridgebot/card.{type Card, Card}
import bridgebot/index.{type Index}
import bridgebot/layout.{type Layout}
import bridgebot/parser/card_parser
import bridgebot/parser/core.{type Parser}
import bridgebot/perspective.{type Perspective, East, West}
import bridgebot/suit
import gleam/list
import party

fn indexes_p() -> Parser(List(Index)) {
  party.choice([
    party.many1(card_parser.index_p()),
    party.char("-") |> core.replace([]),
    core.string_i("void") |> core.replace([]),
  ])
}

fn holding_p() -> Parser(List(Card)) {
  use suits <- party.try(party.sep1(indexes_p(), party.whitespace()))

  case suits {
    [spades, hearts, diamonds, clubs] -> {
      [suit.Spades, suit.Hearts, suit.Diamonds, suit.Clubs]
      |> list.zip([spades, hearts, diamonds, clubs])
      |> list.flat_map(fn(p) { list.map(p.1, fn(i) { Card(p.0, i) }) })
      |> Ok
    }
    _ -> Error("You must provide a holding for all four suits")
  }
}

fn holdings_p() -> Parser(List(List(Card))) {
  party.sep1(holding_p(), party.char(";") |> core.drop_whitespace)
}

fn declarer_p() -> Parser(Layout) {
  use holdings <- party.try(holdings_p())

  layout.declarer_from_holdings(holdings)
}

fn perspective_p() -> Parser(Perspective) {
  use <- party.drop(party.whitespace())
  party.either(
    party.char("<") |> core.replace(West),
    party.char(">") |> core.replace(East),
  )
  |> core.drop_whitespace
}

fn defense_p() -> Parser(Layout) {
  use a <- party.do(holding_p())
  use perspective <- party.do(perspective_p())
  use b <- party.try(holding_p())

  case perspective {
    West -> layout.defense_from_holdings(a, b, perspective)
    East -> layout.defense_from_holdings(b, a, perspective)
  }
}

pub fn layout_p() -> Parser(Layout) {
  party.either(defense_p(), declarer_p())
}
