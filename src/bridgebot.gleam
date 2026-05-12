import argv
import bridgebot/cli
import bridgebot/discord
import gleam/io

pub fn main() {
  case argv.load().arguments {
    ["discord"] -> discord.main()
    ["cli"] -> cli.main()
    _ -> io.println_error("Usage: gleam run [discord | cli]")
  }
}
