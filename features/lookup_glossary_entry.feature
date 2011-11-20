Feature: Lookup glossary entry
  As a glossary user
  I want to find an official translation for a term
  So that I can translate a document

  Background:
    Given the following users:
      | name   | role        |
      | yunike | user        |
      | jens   | contributor |
      | susan  | manager     |
    And a glossary in Japanese and English indexed in Japanese
    And the following glossary entries:
      | English | Japanese | user | note                       | approved? | approved_by |
      | apple   | りんご   | jens | Is there a kanji for this? | yes       | susan       |
      | orange  | オレンジ | jens |                            | no        |             |
      | banana  | バナナ   | jens | Help translate this!       | no        |             |

  Scenario: Glossary user finds approved entry searching in Japanese

  Scenario: Glossary user finds approved entry searching in English

  Scenario: Glossary user fails to find unapproved entry

  Scenario: Glossary user fails to find non-existent entry

  Scenario: Glossary contributor searches for untranslated entries
