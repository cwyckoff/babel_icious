Feature: Babel-icious mapping

Scenario Outline: Mapping from xml to a hash
  Given a mapping exists for '<Source>' to '<Target>' with tag '<MappingTag>'
  When the mapping is translated
  Then the xml should be correctly mapped

  Examples:
  | Source | Target | MappingTag |
  | xml    | hash   | foo 	 |
  | hash   | xml    | bar 	 |
  | hash   | hash   | baz 	 |

Scenario Outline: Mapping with conditions
  Given a mapping exists with '<Condition>' condition
  When the '<Condition>' mapping is translated
  Then the target should be correctly processed for condition '<Condition>'

  Examples:
  | Condition	|
  | unless	|
  | when	|

Scenario Outline: Mapping from xml with multiple nested nodes
  Given a mapping exists with nested nodes
  When the mapping with '<NodeType>' nested nodes is translated
  Then the xml should properly transform nested nodes for '<NodeType>'

  Examples:
  | NodeType		|
  | differently named 	|
  | similarly named 	|
  | partially empty 	|
  | identical 		|

Scenario: Mapping from xml with concatenation
  Given a mapping exists with concatenation
  When the mapping with concatenation is translated
  Then the target should be properly concatenated

