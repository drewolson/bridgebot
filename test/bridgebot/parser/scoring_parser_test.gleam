import bridgebot/parser/core
import bridgebot/parser/scoring_parser
import bridgebot/scoring
import gleeunit/should

pub fn scoring_p_test() {
  core.go(scoring_parser.scoring_p(), "mp")
  |> should.equal(Ok(scoring.Mps))

  core.go(scoring_parser.scoring_p(), "mps")
  |> should.equal(Ok(scoring.Mps))

  core.go(scoring_parser.scoring_p(), "MPS")
  |> should.equal(Ok(scoring.Mps))
}
