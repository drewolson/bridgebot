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
  let p = party.char("a") |> core.replace(1)

  core.go(p, "a")
  |> should.equal(Ok(1))

  core.go(p, "b")
  |> should.be_error
}
