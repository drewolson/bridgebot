import bridgebot/parser/core
import gleeunit/should
import party

pub fn replace_test() {
  let p = party.char("a") |> core.replace(1)

  core.go(p, "a")
  |> should.equal(Ok(1))

  core.go(p, "b")
  |> should.be_error
}

pub fn char_i_test() {
  let p = core.char_i("a")

  core.go(p, "a")
  |> should.equal(Ok("a"))

  core.go(p, "A")
  |> should.equal(Ok("a"))

  core.go(p, "b")
  |> should.be_error
}

pub fn string_i_test() {
  let p = core.string_i("ab")

  core.go(p, "ab")
  |> should.equal(Ok("ab"))

  core.go(p, "AB")
  |> should.equal(Ok("ab"))

  core.go(p, "Ab")
  |> should.equal(Ok("ab"))

  core.go(p, "b")
  |> should.be_error
}
