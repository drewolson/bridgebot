import bridgebot/card
import bridgebot/parser/card_parser
import bridgebot/parser/core
import gleam/result
import gleeunit/should

pub fn card_p_test() {
  core.go(card_parser.card_p(), "sa")
  |> result.map(card.to_string)
  |> should.equal(Ok("♠A"))

  core.go(card_parser.card_p(), "SA")
  |> result.map(card.to_string)
  |> should.equal(Ok("♠A"))
}

pub fn card_p_handles_tens_test() {
  core.go(card_parser.card_p(), "st")
  |> result.map(card.to_string)
  |> should.equal(Ok("♠T"))

  core.go(card_parser.card_p(), "S10")
  |> result.map(card.to_string)
  |> should.equal(Ok("♠T"))
}
