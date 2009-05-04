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

Scenario: Mapping from xml with multiple nested nodes
  Given a mapping exists with nested nodes
  When the mapping with nested nodes is translated
  Then the xml should properly transform nested nodes

Scenario: Mapping from xml with multiple nested nodes some of which have no value
  Given a mapping exists with nested nodes
  When the mapping with partially empty nested nodes is translated
  Then the xml should properly transform partially empty nested nodes

Scenario: Mapping from xml with multiple nested nodes with same name
  Given a mapping exists with nested nodes
  When the mapping with identical nested nodes is translated
  Then the xml should properly transform identical nested nodes

Scenario: Mapping from xml with concatenation
  Given a mapping exists with concatenation
  When the mapping with concatenation is translated
  Then the target should be properly concatenated

Scenario Outline: Mapping with conditions
  Given a mapping exists with '<Condition>' condition
  When the '<Condition>' mapping is translated
  Then the target should be correctly processed for condition '<Condition>'

  Examples:
  | Condition	|
  | unless	|
  | when	|

