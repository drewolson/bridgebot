import bridgebot/diagram.{type Diagram}
import bridgebot/parser/core
import bridgebot/parser/diagram_parser

pub fn parse(input: String) -> Result(Diagram, String) {
  core.go(diagram_parser.diagram_p(), input)
}
