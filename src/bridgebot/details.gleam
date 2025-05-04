import bridgebot/scoring.{type Scoring}
import bridgebot/seat.{type Seat}
import bridgebot/vul.{type Vul}
import gleam/option.{type Option}

pub type Details {
  Details(seat: Option(Seat), vul: Option(Vul), scoring: Option(Scoring))
}
