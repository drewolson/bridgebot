import bridgebot/card.{type Card}
import bridgebot/hand.{type Hand}
import bridgebot/perspective.{type Perspective}
import gleam/dict
import gleam/list
import gleam/result
import gleam/string

pub type Layout {
  DoubleDummy(north: Hand, east: Hand, south: Hand, west: Hand)
  SingleDummy(north: Hand, south: Hand)
  SingleHand(hand: Hand)
  Defense(defender: Hand, dummy: Hand, perspective: Perspective)
}

fn unique_cards(holdings: List(List(Card))) -> Result(Nil, String) {
  let repeats =
    holdings
    |> list.flatten
    |> list.filter(card.is_known)
    |> list.group(fn(c) { c })
    |> dict.to_list
    |> list.filter_map(fn(p) {
      case list.length(p.1) {
        1 -> Error(Nil)
        _ -> Ok(string.inspect(p.0))
      }
    })

  case list.length(repeats) {
    0 -> Ok(Nil)
    _ -> Error("Repeated cards: " <> string.join(repeats, ", "))
  }
}

fn valid_hand_sizes(holdings: List(List(Card))) -> Result(Nil, String) {
  let lengths = list.map(holdings, list.length)

  case list.all(lengths, fn(s) { s >= 0 && s <= 13 }) {
    False -> Error("All hands must have between 0 and 13 cards")
    True -> Ok(Nil)
  }
}

pub fn declarer_from_holdings(
  holdings: List(List(Card)),
) -> Result(Layout, String) {
  use Nil <- result.try(unique_cards(holdings))
  use Nil <- result.try(valid_hand_sizes(holdings))

  case holdings {
    [north, east, south, west] -> Ok(DoubleDummy(north:, east:, south:, west:))
    [north, south] -> Ok(SingleDummy(north:, south:))
    [hand] -> Ok(SingleHand(hand:))
    _ -> Error("Must provide 1, 2, or 4 hands")
  }
}

pub fn defense_from_holdings(
  defender: List(Card),
  dummy: List(Card),
  perspective: Perspective,
) -> Result(Layout, String) {
  use Nil <- result.try(unique_cards([defender, dummy]))
  use Nil <- result.try(valid_hand_sizes([defender, dummy]))

  Ok(Defense(defender:, dummy:, perspective:))
}
