import bridgebot/parser/core.{type Parser}
import bridgebot/vul
import party

pub fn vul_p() -> Parser(vul.Vul) {
  party.choice([
    core.string_i("ww") |> core.replace(vul.WW),
    core.string_i("wr") |> core.replace(vul.WR),
    core.string_i("rw") |> core.replace(vul.RW),
    core.string_i("rr") |> core.replace(vul.RR),
    core.string_i("w/w") |> core.replace(vul.WW),
    core.string_i("w/r") |> core.replace(vul.WR),
    core.string_i("r/w") |> core.replace(vul.RW),
    core.string_i("r/r") |> core.replace(vul.RR),
  ])
}
