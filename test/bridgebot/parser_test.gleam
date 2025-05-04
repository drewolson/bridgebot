import birdie
import bridgebot/parser
import gleam/list
import gleam/string
import gleeunit/should

pub fn single_hand_test() {
  parser.parse("akx qtxxx jxx tx")
  |> string.inspect
  |> birdie.snap("parser single hand test")
}

pub fn single_hand_with_details_test() {
  parser.parse("akx qtxxx jxx tx, rr, mps")
  |> string.inspect
  |> birdie.snap("parser single hand with details test")
}

pub fn field_order_does_not_matter_test() {
  let fields = ["akx qtxxx jxx tx; qjxxx akx qx xxx", "rr", "mps", "CA"]

  let orig = string.join(fields, ", ")
  let shuffled = fields |> list.shuffle |> string.join(", ")

  let orig_result = parser.parse(orig)
  let shuffled_result = parser.parse(shuffled)

  orig_result
  |> string.inspect
  |> birdie.snap("parser field order does not matter")

  orig_result |> should.be_ok
  orig_result |> should.equal(shuffled_result)
}

pub fn defense_west_test() {
  parser.parse("akxx - - - < qtxx - - -")
  |> string.inspect
  |> birdie.snap("parser defense west")
}

pub fn defense_east_test() {
  parser.parse("akxx - - - > qtxx - - -")
  |> string.inspect
  |> birdie.snap("parser defense east")
}
