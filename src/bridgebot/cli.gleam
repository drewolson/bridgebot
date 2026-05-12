import bridgebot/parser
import bridgebot/pprint
import gleam/io
import in

pub fn main() {
  let assert Ok(content) = in.read_line()

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
