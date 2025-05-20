import birl.{type Time}
import birl/duration
import bridgebot/parser
import bridgebot/pprint
import discord_gleam
import discord_gleam/discord/intents
import discord_gleam/event_handler.{type Packet}
import discord_gleam/types/bot.{type Bot}
import discord_gleam/ws/packets/message.{type MessagePacketData}
import gleam/option
import gleam/order
import gleam/string
import glenvy/env
import logging

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

fn wrap_in_backticks(s: String) -> String {
  "```" <> s <> "```"
}

fn send_dm(bot: Bot, user_id: String, message: String) -> Nil {
  let _ = discord_gleam.send_direct_message(bot, user_id, message, [])

  Nil
}

fn set_log_level() -> Nil {
  let level = case env.get_string("LOG_LEVEL") {
    Ok("DEBUG") -> logging.Debug
    Ok("INFO") -> logging.Info
    _ -> logging.Error
  }

  logging.set_level(level)
}

fn delete_non_dm(bot: Bot, message: MessagePacketData) -> Nil {
  case option.is_some(message.guild_id) {
    False -> Nil
    True -> {
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
  data: MessagePacketData,
  content: String,
) -> Nil {
  logging.log(logging.Info, string.inspect(data))

  delete_non_dm(bot, data)

  case content {
    "help" -> {
      pprint.help()
      |> wrap_in_backticks
      |> send_dm(bot, data.author.id, _)
    }
    _ ->
      case parser.parse(content) {
        Ok(diagram) ->
          diagram
          |> pprint.to_string
          |> prepend_username(data.author.username)
          |> wrap_in_backticks
          |> discord_gleam.send_message(bot, data.channel_id, _, [])
        Error(e) -> {
          { "Error parsing your command: " <> e }
          |> wrap_in_backticks
          |> send_dm(bot, data.author.id, _)
        }
      }
  }
}

fn handler(bot: Bot, packet: Packet) -> Nil {
  case packet {
    event_handler.MessagePacket(message) ->
      case message.d.content {
        "!bridge" <> rest -> {
          let content = trim(rest)
          handle_bridge_message(bot, message.d, content)
        }
        _ -> Nil
      }
    _ -> Nil
  }
}

pub fn run_bot(bot: Bot, last_restart: Time) -> Nil {
  logging.log(logging.Info, "Starting bot")
  logging.log(
    logging.Info,
    "Last restart at: " <> birl.to_iso8601(last_restart),
  )

  let now = birl.utc_now()
  let diff = birl.difference(now, last_restart)

  case duration.compare(diff, duration.minutes(1)) {
    order.Gt -> {
      logging.log(logging.Info, "Running...")
      discord_gleam.run(bot, [handler])
      run_bot(bot, now)
    }
    _ ->
      logging.log(
        logging.Info,
        "Refusing to restart, last restart was too recent",
      )
  }
}

pub fn main() {
  logging.configure()

  set_log_level()

  let assert Ok(token) = env.get_string("DISCORD_TOKEN")
  let assert Ok(client_id) = env.get_string("DISCORD_CLIENT_ID")

  let bot = discord_gleam.bot(token, client_id, intents.default())

  birl.utc_now()
  |> birl.subtract(duration.minutes(2))
  |> run_bot(bot, _)
}
