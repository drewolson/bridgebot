import bridgebot/parser/core.{type Parser}
import bridgebot/scoring
import party

fn plural_i(s: String) -> Parser(String) {
  use str <- party.do(core.string_i(s))
  use end <- party.map(party.either(core.string_i("s"), party.return("")))

  str <> end
}

pub fn scoring_p() -> Parser(scoring.Scoring) {
  party.choice([
    plural_i("mp") |> core.replace(scoring.Mps),
    plural_i("imp") |> core.replace(scoring.Imps),
    plural_i("bam") |> core.replace(scoring.Bam),
  ])
}
