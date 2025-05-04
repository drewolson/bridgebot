import bridgebot/parser/core.{type Parser}
import bridgebot/seat
import party

pub fn seat_p() -> Parser(seat.Seat) {
  party.choice([
    core.string_i("1st") |> core.replace(seat.First),
    core.string_i("2nd") |> core.replace(seat.Second),
    core.string_i("3rd") |> core.replace(seat.Third),
    core.string_i("4th") |> core.replace(seat.Fourth),
  ])
}
