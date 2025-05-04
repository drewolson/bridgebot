import bridgebot/parser/core
import bridgebot/parser/vul_parser
import bridgebot/vul
import gleeunit/should

pub fn scoring_p_test() {
  core.go(vul_parser.vul_p(), "rr")
  |> should.equal(Ok(vul.RR))

  core.go(vul_parser.vul_p(), "RR")
  |> should.equal(Ok(vul.RR))
}
