import bridgebot/parser/card_parser
import bridgebot/parser/core
import gleam/result
import gleam/string
import gleeunit/should

pub fn card_p_test() {
  core.go(card_parser.card_p(), "sa")
  |> result.map(string.inspect)
  |> should.equal(Ok("Card(Spades, Known(Ace))"))

  core.go(card_parser.card_p(), "SA")
  |> result.map(string.inspect)
  |> should.equal(Ok("Card(Spades, Known(Ace))"))
}

pub fn card_p_handles_tens_test() {
  core.go(card_parser.card_p(), "st")
  |> result.map(string.inspect)
  |> should.equal(Ok("Card(Spades, Known(Ten))"))

  core.go(card_parser.card_p(), "S10")
  |> result.map(string.inspect)
  |> should.equal(Ok("Card(Spades, Known(Ten))"))
}
