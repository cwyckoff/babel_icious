Scenario: Mapping from xml to a hash
  Given a mapping exists for 'xml to hash'
  When the mapping is translated
  Then the xml should be transformed into a properly mapped hash

Scenario: Mapping from hash to xml
  Given a mapping exists for 'hash to xml'
  When the mapping is translated
  Then the hash should be transformed into a properly mapped xml string

