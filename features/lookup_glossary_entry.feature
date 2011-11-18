Feature: Lookup glossary entry
  As a glossary user
  I want to find an official translation for a term
  So that I can translate a document

  Background:
    Given the following users:
      | name | role        |
      | jens | contributor |
    And the following glossary entries:
      | :en   | :ja    | user | note                       | approved? |
      | apple | りんご | jens | Is there a kanji for this? | yes       |

  Scenario: Search term found

  Scenario: Search term not found
