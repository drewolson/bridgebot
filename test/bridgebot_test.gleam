import birdie
import bridgebot/parser
import bridgebot/pprint
import gleeunit

pub fn main() {
  gleeunit.main()
}

pub fn single_hand_test() {
  let assert Ok(diagram) = parser.parse("akx qtxxx jxx tx, rr, mps")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot single hand")
}

pub fn optional_slash_for_vul_test() {
  let assert Ok(diagram) = parser.parse("akx qtxxx jxx tx, r/r, mps")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot optional slash for vul")
}

pub fn single_dummy_test() {
  let assert Ok(diagram) =
    parser.parse("akx qtxxx jxx tx; qjxxx akx qx xxx, rr, mps")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot single dummy")
}

pub fn single_dummy_with_lead_test() {
  let assert Ok(diagram) =
    parser.parse("akx qtxxx jxx tx; qjxxx akx qx xxx, rr, mps, ca")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot single dummy with lead")
}

pub fn double_dummy_test() {
  let assert Ok(diagram) =
    parser.parse(
      "t987 6543 - 76532; akqj akqj ak kj9; - - q8765432 aqt84; 65432 t9872 jt9 -, rr, imps",
    )

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot double dummy")
}

pub fn defender_west_test() {
  let assert Ok(diagram) =
    parser.parse("t987 6543 - 76532 < akqj akqj ak kj9, rr, imps")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot defender west")
}

pub fn defender_east_test() {
  let assert Ok(diagram) =
    parser.parse("t987 6543 - 76532 > akqj akqj ak kj9, rr, imps")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot defender east")
}

pub fn defender_east_with_lead_test() {
  let assert Ok(diagram) =
    parser.parse("t987 6543 - 76532 > akqj akqj ak kj9, rr, imps, ca")

  diagram
  |> pprint.to_string
  |> birdie.snap("bridgebot defender east with lead")
}
