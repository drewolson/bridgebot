pub type Seat {
  First
  Second
  Third
  Fourth
}

pub fn to_string(seat: Seat) -> String {
  case seat {
    First -> "1st seat"
    Second -> "2nd seat"
    Third -> "3rd seat"
    Fourth -> "4th seat"
  }
}
