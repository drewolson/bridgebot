import bridgebot/card
import bridgebot/parser/card_parser
import bridgebot/parser/core
import gleam/result

pub fn card_p_test() {
  assert result.map(core.go(card_parser.card_p(), "sa"), card.to_string) == Ok("♠A")

  assert result.map(core.go(card_parser.card_p(), "SA"), card.to_string) == Ok("♠A")
}

pub fn card_p_handles_tens_test() {
  assert result.map(core.go(card_parser.card_p(), "st"), card.to_string) == Ok("♠T")

  assert result.map(core.go(card_parser.card_p(), "S10"), card.to_string) == Ok("♠T")
}
