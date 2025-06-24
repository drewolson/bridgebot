import bridgebot/parser
import gleam/list
import gleam/string

pub fn field_order_does_not_matter_test() {
  let fields = ["akx qtxxx jxx tx; qjxxx akx qx xxx", "rr", "mps", "CA"]

  let orig = string.join(fields, ", ")
  let shuffled = fields |> list.shuffle |> string.join(", ")

  let orig_result = parser.parse(orig)
  let shuffled_result = parser.parse(shuffled)

  let assert Ok(_) = orig_result
  assert orig_result == shuffled_result
}

pub fn single_hand_must_contain_13_cards_test() {
  let result = parser.parse("qjxxx akx qx xx")

  assert result == Error("A single hand must contain 13 cards, found 12")
}
