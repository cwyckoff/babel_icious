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

Scenario: Mapping with additional options
  Given a mapping exists with concatenation
  When the concatenated mapping is translated
  Then the xml should properly concatenate node content

