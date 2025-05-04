import bridgebot/parser/core
import bridgebot/parser/layout_parser
import gleam/result
import gleam/string
import gleeunit/should

pub fn single_hand_test() {
  core.go(layout_parser.layout_p(), "akx qtxxx jxx tx")
  |> result.map(string.inspect)
  |> should.equal(Ok(
    "SingleHand([Card(Spades, Known(Ace)), Card(Spades, Known(King)), Card(Spades, Unknown), Card(Hearts, Known(Queen)), Card(Hearts, Known(Ten)), Card(Hearts, Unknown), Card(Hearts, Unknown), Card(Hearts, Unknown), Card(Diamonds, Known(Jack)), Card(Diamonds, Unknown), Card(Diamonds, Unknown), Card(Clubs, Known(Ten)), Card(Clubs, Unknown)])",
  ))

  core.go(layout_parser.layout_p(), "- - - void")
  |> result.map(string.inspect)
  |> should.equal(Ok("SingleHand([])"))
}

pub fn single_dummy_test() {
  core.go(layout_parser.layout_p(), "akx - - -; jtxxx - - -")
  |> result.map(string.inspect)
  |> should.equal(Ok(
    "SingleDummy([Card(Spades, Known(Ace)), Card(Spades, Known(King)), Card(Spades, Unknown)], [Card(Spades, Known(Jack)), Card(Spades, Known(Ten)), Card(Spades, Unknown), Card(Spades, Unknown), Card(Spades, Unknown)])",
  ))
}
