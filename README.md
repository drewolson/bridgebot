# bridgebot

A discord bot for generating plain text bridge diagrams. This project is a
[gleam](https://gleam.run) rewrite of the
[bridge-diagrams](https://github.com/drewolson/bridge-diagrams) project.

## Running

The Discord bot needs a `DISCORD_TOKEN` with scopes that allow for connecting to
the server, sending messages, and managing messages. It also needs a
`DISCORD_CLIENT_ID`. Both are provided as environment variables.

```
DISCORD_TOKEN=<redacted> DISCORD_CLIENT_ID=<redacted> gleam run
```

Once associated with a server, messages prefixed with `!bridge` or `!bridgebot`
will be handled by the bot.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
