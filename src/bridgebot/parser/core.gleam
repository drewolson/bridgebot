import gleam/string
import party.{Unexpected, UserError}

pub type Parser(a) =
  party.Parser(a, String)

pub fn go(parser: Parser(a), input: String) -> Result(a, String) {
  case party.go(parser, input) {
    Ok(v) -> Ok(v)
    Error(UserError(_, e)) -> Error(e)
    Error(Unexpected(_, e)) -> Error(e)
  }
}

pub fn drop_whitespace(p: Parser(a)) -> Parser(a) {
  use a <- party.do(p)
  use <- party.drop(party.whitespace())

  party.return(a)
}

pub fn replace(p: Parser(a), v: b) -> Parser(b) {
  use <- party.drop(p)

  party.return(v)
}

pub fn char_i(c: String) -> Parser(String) {
  party.choice([
    party.char(string.lowercase(c)),
    party.char(string.uppercase(c)),
  ])
  |> party.map(string.lowercase)
}

fn string_i_aux(s: String, chars: List(String)) -> Parser(String) {
  case chars {
    [] -> party.return(s)
    [h, ..t] -> {
      use <- party.drop(char_i(h))

      string_i_aux(s, t)
    }
  }
}

pub fn string_i(s: String) -> Parser(String) {
  string_i_aux(s, string.to_graphemes(s))
}
