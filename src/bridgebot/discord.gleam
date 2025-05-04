import bridgebot/parser
import bridgebot/pprint
import discord_gleam
import discord_gleam/discord/intents
import discord_gleam/discord/snowflake
import discord_gleam/event_handler.{type Packet}
import discord_gleam/http/request
import discord_gleam/types/bot.{type Bot}
import discord_gleam/ws/packets/message.{
  type MessageAuthor, type MessagePacketData,
}
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

fn delete_non_dm(bot: Bot, message: MessagePacketData) -> Nil {
  case message.guild_id {
    "" -> Nil
    _ -> {
      discord_gleam.delete_message(
        bot,
        message.channel_id,
        message.id,
        "bridge bot",
      )

      Nil
    }
  }
}

fn handle_bridge_message(
  bot: Bot,
  message: MessagePacketData,
  content: String,
) -> Nil {
  logging.log(logging.Info, string.inspect(message))

  delete_non_dm(bot, message)

  case content {
    "help" -> {
      use channel <- with_dm(bot, message.author)

      pprint.help()
      |> wrap_in_backticks
      |> discord_gleam.send_message(bot, channel.id, _, [])
    }
    _ ->
      case parser.parse(content) {
        Ok(diagram) -> {
          diagram
          |> pprint.to_string
          |> prepend_username(message.author.username)
          |> wrap_in_backticks
          |> discord_gleam.send_message(bot, message.channel_id, _, [])
        }
        Error(e) -> {
          use channel <- with_dm(bot, message.author)
          let error = wrap_in_backticks("Error parsing your command: " <> e)

          discord_gleam.send_message(bot, channel.id, error, [])
        }
      }
  }
}

fn handle_message(bot: Bot, message: MessagePacketData) -> Nil {
  case message.content {
    "!bridge" <> rest -> {
      let content = trim(rest)
      handle_bridge_message(bot, message, content)
    }
    _ -> Nil
  }
}

fn handler(bot: Bot, packet: Packet) -> Nil {
  case packet {
    event_handler.UnknownPacket(generic) if generic.t == "MESSAGE_CREATE" -> {
      let decoder = {
        use content <- decode.field("content", decode.string)
        use id <- decode.field("id", snowflake.decoder())
        use guild_id <- decode.optional_field(
          "guild_id",
          "",
          snowflake.decoder(),
        )
        use channel_id <- decode.field("channel_id", snowflake.decoder())
        use author <- decode.field("author", {
          use id <- decode.field("id", snowflake.decoder())
          use username <- decode.field("username", decode.string)
          decode.success(message.MessageAuthor(id:, username:))
        })
        decode.success(message.MessagePacketData(
          content:,
          id:,
          guild_id:,
          channel_id:,
          author:,
        ))
      }

      case decode.run(generic.d, decoder) {
        Ok(data) -> handle_message(bot, data)
        Error(_) -> Nil
      }
    }

    event_handler.MessagePacket(message) -> handle_message(bot, message.d)
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
      intents.Intents(
        message_content: True,
        guild_messages: True,
        direct_messages: True,
      ),
    )

  discord_gleam.run(bot, [handler])
}
