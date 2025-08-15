import bridgebot/parser
import bridgebot/pprint
import gleam/io
import gleam/yielder
import stdin

pub fn main() {
  let assert Ok(content) =
    stdin.read_lines()
    |> yielder.first()

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
