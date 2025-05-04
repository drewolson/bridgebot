import bridgebot/parser
import bridgebot/pprint
import gleam/erlang
import gleam/io

pub fn main() {
  let assert Ok(content) = erlang.get_line("")

  case parser.parse(content) {
    Ok(diagram) -> {
      diagram
      |> pprint.to_string
      |> io.println
    }
    Error(e) -> {
      let error = "Error parsing your command: " <> e

      io.println_error(error)
    }
  }
}
