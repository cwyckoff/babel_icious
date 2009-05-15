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

Scenario: Mapping hash with custom block
  Given a mapping exists with a customized block
  When the customized mapping is translated
  Then the customized target should be correctly processed 

 Scenario: Mapping from xml with concatenation
  Given a mapping exists with concatenation
  When the mapping with concatenation is translated
  Then the target should be properly concatenated

Scenario: Mapping with .from and .to methods
  Given a mapping exists with custom .to method
  When the mapping with custom .to method is translated
  Then the target should be correctly processed for custom .to conditions
