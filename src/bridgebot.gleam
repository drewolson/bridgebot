import bridgebot/parser
import bridgebot/pprint
import discord_gleam
import discord_gleam/discord/intents
import discord_gleam/event_handler.{type Packet}
import discord_gleam/http/request
import discord_gleam/types/bot.{type Bot}
import discord_gleam/ws/packets/message.{type MessageAuthor, type MessagePacket}
import envoy
import gleam/dynamic/decode
import gleam/hackney
import gleam/http
import gleam/json
import gleam/result
import gleam/string
import logging

type Channel {
  Channel(id: String)
}

fn trim(str: String) -> String {
  let str = case str {
    "bot" <> rest -> rest
    s -> s
  }

  string.trim(str)
}

fn prepend_username(str: String, username: String) -> String {
  "\n@" <> username <> "\n\n" <> str
}

fn with_dm(bot: Bot, author: MessageAuthor, f: fn(Channel) -> Nil) -> Nil {
  let channel_decoder = {
    use id <- decode.field("id", decode.string)
    decode.success(Channel(id:))
  }
  let body =
    json.object([#("recipient_id", json.string(author.id))]) |> json.to_string
  let path = "/users/@me/channels"
  let req = request.new_auth_post(http.Post, path, bot.token, body)
  let res = {
    use resp <- result.try(hackney.send(req) |> result.replace_error(Nil))
    json.parse(resp.body, channel_decoder) |> result.replace_error(Nil)
  }

  case res {
    Ok(channel) -> f(channel)
    Error(_) -> Nil
  }
}

fn wrap_in_backticks(s: String) -> String {
  "```" <> s <> "```"
}

fn set_log_level() -> Nil {
  let level = case envoy.get("LOG_LEVEL") {
    Ok("DEBUG") -> logging.Debug
    Ok("INFO") -> logging.Info
    _ -> logging.Error
  }

  logging.set_level(level)
}

fn handle_message(bot: Bot, message: MessagePacket, content: String) -> Nil {
  discord_gleam.delete_message(
    bot,
    message.d.channel_id,
    message.d.id,
    "bridge bot",
  )

  case content {
    "help" -> {
      use channel <- with_dm(bot, message.d.author)

      pprint.help()
      |> wrap_in_backticks
      |> discord_gleam.send_message(bot, channel.id, _, [])
    }
    _ ->
      case parser.parse(content) {
        Ok(diagram) -> {
          diagram
          |> pprint.to_string
          |> prepend_username(message.d.author.username)
          |> wrap_in_backticks
          |> discord_gleam.send_message(bot, message.d.channel_id, _, [])
        }
        Error(e) -> {
          use channel <- with_dm(bot, message.d.author)
          let error = wrap_in_backticks("Error parsing your command: " <> e)

          discord_gleam.send_message(bot, channel.id, error, [])
        }
      }
  }
}

fn handler(bot: Bot, packet: Packet) -> Nil {
  case packet {
    event_handler.MessagePacket(message) -> {
      case message.d.content {
        "!bridge" <> rest -> {
          logging.log(logging.Info, string.inspect(packet))

          let content = trim(rest)
          handle_message(bot, message, content)
        }
        _ -> Nil
      }
    }
    _ -> Nil
  }
}

pub fn main() {
  logging.configure()

  set_log_level()

  let assert Ok(token) = envoy.get("DISCORD_TOKEN")
  let assert Ok(client_id) = envoy.get("DISCORD_CLIENT_ID")

  let bot =
    discord_gleam.bot(
      token,
      client_id,
      intents.Intents(message_content: True, guild_messages: True),
    )

  discord_gleam.run(bot, [handler])
}
