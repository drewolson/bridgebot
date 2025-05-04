import gleam/int
import gleam/order.{type Order}

pub type Rank {
  Ace
  King
  Queen
  Jack
  Ten
  Nine
  Eight
  Seven
  Six
  Five
  Four
  Three
  Two
}

fn to_int(rank: Rank) -> Int {
  case rank {
    Ace -> 14
    King -> 13
    Queen -> 12
    Jack -> 11
    Ten -> 10
    Nine -> 9
    Eight -> 8
    Seven -> 7
    Six -> 6
    Five -> 5
    Four -> 4
    Three -> 3
    Two -> 2
  }
}

pub fn compare(a: Rank, b: Rank) -> Order {
  int.compare(to_int(a), to_int(b))
}

pub fn to_string(rank: Rank) -> String {
  case rank {
    Ace -> "A"
    King -> "K"
    Queen -> "Q"
    Jack -> "J"
    Ten -> "T"
    Nine -> "9"
    Eight -> "8"
    Seven -> "7"
    Six -> "6"
    Five -> "5"
    Four -> "4"
    Three -> "3"
    Two -> "2"
  }
}
