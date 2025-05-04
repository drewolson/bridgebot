pub type Vul {
  WW
  WR
  RW
  RR
}

pub fn to_string(vul: Vul) -> String {
  case vul {
    WW -> "W/W"
    WR -> "W/R"
    RW -> "R/W"
    RR -> "R/R"
  }
}
