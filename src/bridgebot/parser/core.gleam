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

fn insensitive(f: fn(String) -> Parser(String), s: String) -> Parser(String) {
  party.choice([f(string.lowercase(s)), f(string.uppercase(s))])
  |> party.map(string.lowercase)
}

pub fn string_i(s: String) -> Parser(String) {
  insensitive(party.string, s)
}

pub fn char_i(c: String) -> Parser(String) {
  insensitive(party.char, c)
}
