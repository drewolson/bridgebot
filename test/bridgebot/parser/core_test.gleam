import bridgebot/parser/core
import party

pub fn replace_test() {
  let p = party.char("a") |> core.replace(1)

  assert core.go(p, "a") == Ok(1)

  let assert Error(_) = core.go(p, "b")
}

pub fn char_i_test() {
  let p = core.char_i("a")

  assert core.go(p, "a") == Ok("a")

  assert core.go(p, "A") == Ok("a")

  let assert Error(_) = core.go(p, "b")
}

pub fn string_i_test() {
  let p = core.string_i("ab")

  assert core.go(p, "ab") == Ok("ab")

  assert core.go(p, "AB") == Ok("ab")

  assert core.go(p, "Ab") == Ok("ab")

  let assert Error(_) = core.go(p, "b")
}
