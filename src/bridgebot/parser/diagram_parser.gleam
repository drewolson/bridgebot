import bridgebot/card.{type Card}
import bridgebot/details.{Details}
import bridgebot/diagram.{type Diagram, Diagram}
import bridgebot/layout.{type Layout}
import bridgebot/parser/card_parser
import bridgebot/parser/core.{type Parser}
import bridgebot/parser/layout_parser
import bridgebot/parser/scoring_parser
import bridgebot/parser/seat_parser
import bridgebot/parser/vul_parser
import bridgebot/scoring.{type Scoring}
import bridgebot/seat.{type Seat}
import bridgebot/vul.{type Vul}
import gleam/dict.{type Dict}
import gleam/option.{type Option, None, Some}
import gleam/result
import party

const layout_key = "layout"

const lead_key = "lead"

const vul_key = "vul"

const scoring_key = "scoring"

const seat_key = "seat"

type Field {
  LayoutField(Layout)
  LeadField(Card)
  VulField(Vul)
  ScoringField(Scoring)
  SeatField(Seat)
}

fn fetch_layout(fields: Dict(String, Field)) -> Result(Layout, String) {
  case dict.get(fields, layout_key) {
    Ok(LayoutField(layout)) -> Ok(layout)
    Error(Nil) -> Error("No layout provided")
    _ -> Error("Invalid layout")
  }
}

fn fetch_lead(fields: Dict(String, Field)) -> Option(Card) {
  case dict.get(fields, lead_key) {
    Ok(LeadField(lead)) -> Some(lead)
    _ -> None
  }
}

fn fetch_vul(fields: Dict(String, Field)) -> Option(Vul) {
  case dict.get(fields, vul_key) {
    Ok(VulField(vul)) -> Some(vul)
    _ -> None
  }
}

fn fetch_scoring(fields: Dict(String, Field)) -> Option(Scoring) {
  case dict.get(fields, scoring_key) {
    Ok(ScoringField(scoring)) -> Some(scoring)
    _ -> None
  }
}

fn fetch_seat(fields: Dict(String, Field)) -> Option(Seat) {
  case dict.get(fields, seat_key) {
    Ok(SeatField(seat)) -> Some(seat)
    _ -> None
  }
}

fn layout_field_p() -> Parser(#(String, Field)) {
  use layout <- party.map(layout_parser.layout_p())

  #(layout_key, LayoutField(layout))
}

fn lead_field_p() -> Parser(#(String, Field)) {
  use lead <- party.map(card_parser.card_p())

  #(lead_key, LeadField(lead))
}

fn vul_field_p() -> Parser(#(String, Field)) {
  use vul <- party.map(vul_parser.vul_p())

  #(vul_key, VulField(vul))
}

fn scoring_field_p() -> Parser(#(String, Field)) {
  use scoring <- party.map(scoring_parser.scoring_p())

  #(scoring_key, ScoringField(scoring))
}

fn seat_field_p() -> Parser(#(String, Field)) {
  use seat <- party.map(seat_parser.seat_p())

  #(seat_key, SeatField(seat))
}

fn fields_p() -> Parser(Dict(String, Field)) {
  use fields <- party.map(party.sep1(
    party.choice([
      layout_field_p(),
      lead_field_p(),
      vul_field_p(),
      scoring_field_p(),
      seat_field_p(),
    ]),
    party.string(",") |> core.drop_whitespace,
  ))

  dict.from_list(fields)
}

pub fn diagram_p() -> Parser(Diagram) {
  use fields <- party.try(fields_p())
  use layout <- result.map(fetch_layout(fields))
  let lead = fetch_lead(fields)
  let seat = fetch_seat(fields)
  let vul = fetch_vul(fields)
  let scoring = fetch_scoring(fields)
  let details = Details(seat:, vul:, scoring:)

  Diagram(layout:, lead:, details:)
}
