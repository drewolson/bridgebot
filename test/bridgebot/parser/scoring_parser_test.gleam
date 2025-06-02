import bridgebot/parser/core
import bridgebot/parser/scoring_parser
import bridgebot/scoring

pub fn scoring_p_test() {
  assert core.go(scoring_parser.scoring_p(), "mp") == Ok(scoring.Mps)

  assert core.go(scoring_parser.scoring_p(), "mps") == Ok(scoring.Mps)

  assert core.go(scoring_parser.scoring_p(), "MPS") == Ok(scoring.Mps)
}
