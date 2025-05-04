import bridgebot/index.{type Index, Known}
import bridgebot/suit.{type Suit}
import gleam/order.{type Order, Eq}

pub type Card {
  Card(suit: Suit, index: Index)
}

pub fn is_known(card: Card) -> Bool {
  case card {
    Card(_, Known(_)) -> True
    _ -> False
  }
}

pub fn to_string(card: Card) -> String {
  suit.to_string(card.suit) <> index.to_string(card.index)
}

pub fn compare(a: Card, b: Card) -> Order {
  case suit.compare(a.suit, b.suit) {
    Eq -> index.compare(a.index, b.index)
    r -> r
  }
}
