pub type Scoring {
  Mps
  Imps
  Bam
}

pub fn to_string(scoring: Scoring) -> String {
  case scoring {
    Mps -> "MPs"
    Imps -> "IMPs"
    Bam -> "BAM"
  }
}
