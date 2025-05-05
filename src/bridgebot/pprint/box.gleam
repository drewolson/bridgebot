import bridgebot/card.{type Card}
import bridgebot/details
import bridgebot/hand
import bridgebot/index
import bridgebot/scoring
import bridgebot/seat
import bridgebot/suit
import bridgebot/vul
import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/order
import gleam/result
import gleam/string

pub opaque type Box {
  Box(lines: List(String))
}

fn pad(box: Box, n: Int) -> Box {
  box.lines
  |> list.map(string.pad_end(_, n, " "))
  |> Box
}

fn expand(box: Box, rows: Int, cols: Int) -> Box {
  let lines = list.map(box.lines, string.pad_end(_, cols, " "))
  let blanks = list.repeat(string.repeat(" ", cols), rows - list.length(lines))

  lines
  |> list.append(blanks)
  |> Box
}

fn standardize(boxes: List(Box)) -> List(Box) {
  let rows =
    boxes
    |> list.map(fn(b) { list.length(b.lines) })
    |> list.max(int.compare)
    |> result.unwrap(0)

  let cols =
    boxes
    |> list.flat_map(fn(b) { list.map(b.lines, string.length) })
    |> list.max(int.compare)
    |> result.unwrap(0)

  list.map(boxes, fn(b) { expand(b, rows, cols) })
}

fn standardize_one(box: Box) -> Box {
  let assert Ok(first) =
    [box]
    |> list.first

  first
}

pub fn columns(boxes: List(Box)) -> Box {
  boxes
  |> standardize
  |> list.map(fn(b) { b.lines })
  |> list.transpose
  |> list.map(string.join(_, " "))
  |> Box
}

pub fn rows(boxes: List(Box)) -> Box {
  boxes
  |> list.map(fn(b) { b.lines })
  |> list.flatten
  |> Box
  |> standardize_one
}

pub fn hand(hand: hand.Hand) -> Box {
  let suits = list.group(hand, fn(h) { h.suit })

  [suit.Spades, suit.Hearts, suit.Diamonds, suit.Clubs]
  |> list.map(fn(s) { #(s, dict.get(suits, s) |> result.unwrap([])) })
  |> list.map(fn(p) {
    let #(suit, cards) = p
    let indexes =
      cards
      |> list.sort(order.reverse(card.compare))
      |> list.map(fn(c) { index.to_string(c.index) })
      |> string.join("")

    suit.to_string(suit) <> indexes
  })
  |> Box
  |> pad(10)
}

pub fn details(details: details.Details) -> Box {
  [
    option.map(details.seat, seat.to_string),
    option.map(details.vul, vul.to_string),
    option.map(details.scoring, scoring.to_string),
  ]
  |> option.values
  |> Box
  |> pad(10)
}

pub fn lead(card: Card) -> Box {
  Box(["Lead: " <> card.to_string(card)])
  |> pad(10)
}

pub fn empty(n: Int) -> Box {
  Box([""])
  |> pad(n)
}

pub fn compass() -> Box {
  Box([" ----- ", "|  N  |", "|W   E|", "|  S  |", " ----- "])
}

pub fn compass_ne() -> Box {
  Box([" ----- ", "|  N  |", "|    E|", "|     |", " ----- "])
}

pub fn compass_nw() -> Box {
  Box([" ----- ", "|  N  |", "|W    |", "|     |", " ----- "])
}

pub fn to_string(box: Box) -> String {
  box.lines |> list.map(string.trim_end) |> string.join("\n")
}
