import bridgebot/rank.{type Rank}
import gleam/order.{type Order, Eq, Gt, Lt}

pub type Index {
  Known(rank: Rank)
  Unknown
}

pub fn compare(a: Index, b: Index) -> Order {
  case a, b {
    Unknown, Unknown -> Eq
    Unknown, _ -> Lt
    _, Unknown -> Gt
    Known(rank: ra), Known(rank: rb) -> rank.compare(ra, rb)
  }
}

pub fn to_string(index: Index) -> String {
  case index {
    Unknown -> "x"
    Known(rank) -> rank.to_string(rank)
  }
}
