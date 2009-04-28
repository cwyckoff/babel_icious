Feature: Babel-icious mapping

Scenario Outline: Mapping from xml to a hash
  Given a mapping exists for '<Source>' to '<Target>' with tag '<MappingTag>'
  When the mapping is translated
  Then the xml should be correctly mapped

  Examples:
  | Source | Target | MappingTag |
  | xml    | hash   | foo 	 |
  | hash   | xml    | bar 	 |

Scenario: Mapping from xml with multiple nested nodes with same name
  Given a mapping exists with identical nested nodes
  When the mapping with nested nodes is translated
  Then the xml should properly transform nested nodes

Scenario Outline: Mapping with conditions
  Given a mapping exists with '<Condition>' condition
  When the '<Condition>' mapping is translated
  Then the target should be correctly processed for condition '<Condition>'

  Examples:
  | Condition	|
  | unless	|
  | when	|
  | concatenate	|

