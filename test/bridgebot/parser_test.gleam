import bridgebot/parser
import gleam/list
import gleam/string
import gleeunit/should

pub fn field_order_does_not_matter_test() {
  let fields = ["akx qtxxx jxx tx; qjxxx akx qx xxx", "rr", "mps", "CA"]

  let orig = string.join(fields, ", ")
  let shuffled = fields |> list.shuffle |> string.join(", ")

  let orig_result = parser.parse(orig)
  let shuffled_result = parser.parse(shuffled)

  orig_result |> should.be_ok
  orig_result |> should.equal(shuffled_result)
}
