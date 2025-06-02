import bridgebot/parser/core
import bridgebot/parser/vul_parser
import bridgebot/vul

pub fn scoring_p_test() {
  assert core.go(vul_parser.vul_p(), "rr") == Ok(vul.RR)

  assert core.go(vul_parser.vul_p(), "RR") == Ok(vul.RR)
}
