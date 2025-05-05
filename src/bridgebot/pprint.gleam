import bridgebot/card
import bridgebot/details
import bridgebot/diagram
import bridgebot/hand
import bridgebot/layout
import bridgebot/perspective
import bridgebot/pprint/box
import bridgebot/pprint/help
import gleam/option.{type Option, None, Some}

pub fn help() -> String {
  help.to_string()
}

pub fn to_string(diagram: diagram.Diagram) {
  let diagram.Diagram(layout:, lead:, details:) = diagram

  case layout {
    layout.DoubleDummy(north:, east:, south:, west:) ->
      double_dummy_to_string(north, south, east, west, details)
    layout.SingleDummy(north:, south:) ->
      single_dummy_to_string(north, south, lead, details)
    layout.SingleHand(hand:) -> single_hand_to_string(hand, details)
    layout.Defense(defender:, dummy:, perspective:) ->
      defense_to_string(defender, dummy, perspective, lead, details)
  }
}

fn double_dummy_to_string(
  north: hand.Hand,
  east: hand.Hand,
  south: hand.Hand,
  west: hand.Hand,
  details: details.Details,
) -> String {
  box.rows([
    box.columns([box.details(details), box.hand(north)]),
    box.columns([box.hand(west), box.compass(), box.hand(east)]),
    box.columns([box.empty(10), box.hand(south)]),
  ])
  |> box.to_string
}

fn single_dummy_to_string(
  north: hand.Hand,
  south: hand.Hand,
  lead: Option(card.Card),
  details: details.Details,
) -> String {
  case lead {
    None ->
      box.rows([
        box.columns([box.hand(north), box.details(details)]),
        box.empty(10),
        box.hand(south),
      ])
      |> box.to_string
    Some(card) ->
      box.rows([
        box.columns([box.details(details), box.hand(north)]),
        box.lead(card),
        box.columns([box.empty(10), box.hand(south)]),
      ])
      |> box.to_string
  }
}

fn single_hand_to_string(hand: hand.Hand, details: details.Details) -> String {
  box.columns([box.hand(hand), box.details(details)])
  |> box.to_string
}

fn defense_to_string(
  defender: hand.Hand,
  dummy: hand.Hand,
  perspective: perspective.Perspective,
  lead: Option(card.Card),
  details: details.Details,
) -> String {
  case perspective, lead {
    perspective.East, None ->
      box.rows([
        box.columns([box.hand(dummy), box.details(details)]),
        box.columns([box.compass_ne(), box.hand(defender)]),
      ])
      |> box.to_string
    perspective.East, Some(lead) ->
      box.rows([
        box.columns([box.details(details), box.hand(dummy)]),
        box.columns([box.lead(lead), box.compass_ne(), box.hand(defender)]),
      ])
      |> box.to_string
    perspective.West, _ ->
      box.rows([
        box.columns([box.details(details), box.hand(dummy)]),
        box.columns([box.hand(defender), box.compass_nw()]),
      ])
      |> box.to_string
  }
}
