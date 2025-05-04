import gleam/int
import gleam/order.{type Order}

pub type Suit {
  Spades
  Hearts
  Diamonds
  Clubs
}

fn to_int(suit: Suit) -> Int {
  case suit {
    Clubs -> 1
    Diamonds -> 2
    Hearts -> 3
    Spades -> 4
  }
}

pub fn compare(a: Suit, b: Suit) -> Order {
  int.compare(to_int(a), to_int(b))
}

pub fn to_string(suit: Suit) -> String {
  case suit {
    Spades -> "♠"
    Hearts -> "♥"
    Diamonds -> "♦"
    Clubs -> "♣"
  }
}
