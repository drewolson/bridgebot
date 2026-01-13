import bridgebot/card.{Card}
import bridgebot/index.{Known, Unknown}
import bridgebot/rank.{Ace, King}
import bridgebot/suit.{Hearts, Spades}
import gleam/order.{Gt, Lt}

pub fn order_checks_suit_first_test() {
  let a = Card(suit: Spades, index: Known(Ace))
  let b = Card(suit: Hearts, index: Known(Ace))

  assert card.compare(a, b) == Gt
}

pub fn order_unknowns_less_than_knowns_test() {
  let a = Card(suit: Spades, index: Unknown)
  let b = Card(suit: Spades, index: Known(Ace))

  assert card.compare(a, b) == Lt
}

pub fn order_checks_rank_last_test() {
  let a = Card(suit: Spades, index: Known(King))
  let b = Card(suit: Spades, index: Known(Ace))

  assert card.compare(a, b) == Lt
}
