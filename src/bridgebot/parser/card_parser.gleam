import bridgebot/card.{type Card, Card}
import bridgebot/index
import bridgebot/parser/core.{type Parser}
import bridgebot/rank
import bridgebot/suit
import party

pub fn suit_p() -> Parser(suit.Suit) {
  party.choice([
    core.char_i("s") |> core.replace(suit.Spades),
    core.char_i("h") |> core.replace(suit.Hearts),
    core.char_i("d") |> core.replace(suit.Diamonds),
    core.char_i("c") |> core.replace(suit.Clubs),
  ])
}

pub fn rank_p() -> Parser(rank.Rank) {
  party.choice([
    core.char_i("a") |> core.replace(rank.Ace),
    core.char_i("k") |> core.replace(rank.King),
    core.char_i("q") |> core.replace(rank.Queen),
    core.char_i("j") |> core.replace(rank.Jack),
    party.choice([core.char_i("t"), party.string("10")])
      |> core.replace(rank.Ten),
    party.char("9") |> core.replace(rank.Nine),
    party.char("8") |> core.replace(rank.Eight),
    party.char("7") |> core.replace(rank.Seven),
    party.char("6") |> core.replace(rank.Six),
    party.char("5") |> core.replace(rank.Five),
    party.char("4") |> core.replace(rank.Four),
    party.char("3") |> core.replace(rank.Three),
    party.char("2") |> core.replace(rank.Two),
  ])
}

fn known_p() -> Parser(index.Index) {
  rank_p() |> party.map(index.Known)
}

fn unknown_p() -> Parser(index.Index) {
  core.char_i("x") |> core.replace(index.Unknown)
}

pub fn index_p() -> Parser(index.Index) {
  party.choice([known_p(), unknown_p()])
}

pub fn card_p() -> Parser(Card) {
  use suit <- party.do(suit_p())
  use index <- party.map(index_p())

  Card(suit:, index:)
}

pub fn lead_p() -> Parser(Card) {
  use card <- party.try(card_p())

  case card.is_known(card) {
    True -> Ok(card)
    False -> Error("Lead must be a known card.")
  }
}
