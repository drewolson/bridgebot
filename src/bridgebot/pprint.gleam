import bridgebot/card
import bridgebot/diagram
import bridgebot/hand
import bridgebot/layout
import bridgebot/perspective
import bridgebot/pprint/box
import bridgebot/pprint/help
import bridgebot/scoring
import bridgebot/vul
import gleam/option.{type Option, None, Some}

pub fn help() -> String {
  help.to_string()
}

pub fn to_string(diagram: diagram.Diagram) {
  let diagram.Diagram(layout:, lead:, vul:, scoring:) = diagram

  case layout {
    layout.DoubleDummy(north:, east:, south:, west:) ->
      double_dummy_to_string(north, south, east, west, vul, scoring)
    layout.SingleDummy(north:, south:) ->
      single_dummy_to_string(north, south, lead, vul, scoring)
    layout.SingleHand(hand:) -> single_hand_to_string(hand, vul, scoring)
    layout.Defense(defender:, dummy:, perspective:) ->
      defense_to_string(defender, dummy, perspective, lead, vul, scoring)
  }
}

fn double_dummy_to_string(
  north: hand.Hand,
  east: hand.Hand,
  south: hand.Hand,
  west: hand.Hand,
  vul: Option(vul.Vul),
  scoring: Option(scoring.Scoring),
) -> String {
  box.rows([
    box.columns([box.details(vul, scoring), box.hand(north)]),
    box.columns([box.hand(west), box.compass(), box.hand(east)]),
    box.columns([box.empty(10), box.hand(south)]),
  ])
  |> box.to_string
}

fn single_dummy_to_string(
  north: hand.Hand,
  south: hand.Hand,
  lead: Option(card.Card),
  vul: Option(vul.Vul),
  scoring: Option(scoring.Scoring),
) -> String {
  case lead {
    None ->
      box.rows([
        box.columns([box.hand(north), box.details(vul, scoring)]),
        box.compass(),
        box.hand(south),
      ])
      |> box.to_string
    Some(card) ->
      box.rows([
        box.columns([box.details(vul, scoring), box.hand(north)]),
        box.columns([box.lead(card), box.compass()]),
        box.columns([box.empty(10), box.hand(south)]),
      ])
      |> box.to_string
  }
}

fn single_hand_to_string(
  hand: hand.Hand,
  vul: Option(vul.Vul),
  scoring: Option(scoring.Scoring),
) -> String {
  box.columns([box.hand(hand), box.details(vul, scoring)])
  |> box.to_string
}

fn defense_to_string(
  defender: hand.Hand,
  dummy: hand.Hand,
  perspective: perspective.Perspective,
  lead: Option(card.Card),
  vul: Option(vul.Vul),
  scoring: Option(scoring.Scoring),
) -> String {
  case perspective, lead {
    perspective.East, None ->
      box.rows([
        box.columns([box.hand(dummy), box.details(vul, scoring)]),
        box.columns([box.compass_ne(), box.hand(defender)]),
      ])
      |> box.to_string
    perspective.East, Some(lead) ->
      box.rows([
        box.columns([box.details(vul, scoring), box.hand(dummy)]),
        box.columns([box.lead(lead), box.compass_ne(), box.hand(defender)]),
      ])
      |> box.to_string
    perspective.West, _ ->
      box.rows([
        box.columns([box.details(vul, scoring), box.hand(dummy)]),
        box.columns([box.hand(defender), box.compass_nw()]),
      ])
      |> box.to_string
  }
}
