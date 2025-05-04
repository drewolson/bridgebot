# bridgebot

A discord bot and CLI for generating plain text bridge diagrams. This project is a
[gleam](https://gleam.run) rewrite of the
[bridge-diagrams](https://github.com/drewolson/bridge-diagrams) project.

## Running

### CLI

The CLI reads input from stdin and prints the resulting diagram. Here's the
obligatory hand from
[Moonraker](https://en.wikipedia.org/wiki/Moonraker_(novel)):

```
$ gleam run cli <<< 't987 6543 - 76532; akqj akqj ak kj9; - - q8765432 aqt84; 65432 t9872 jt9 -, r/r, imps'
   Compiled in 0.09s
    Running bridgebot.main
R/R        ♠T987
IMPs       ♥6543
           ♦
           ♣76532
♠65432      -----     ♠
♥T9872     |  N  |    ♥
♦JT9       |W   E|    ♦Q8765432
♣          |  S  |    ♣AQT84
            -----
           ♠AKQJ
           ♥AKQJ
           ♦AK
           ♣KJ9
```

### Discord

The Discord bot needs a `DISCORD_TOKEN` with scopes that allow for connecting to
the server, sending messages, and managing messages. It also needs a
`DISCORD_CLIENT_ID`. Both are provided as environment variables.

```
DISCORD_TOKEN=<redacted> DISCORD_CLIENT_ID=<redacted> gleam run discord
```

Once associated with a server, messages prefixed with `!bridge` or `!bridgebot`
will be handled by the bot.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
