Feature: Add glossary entry
  As a glossary contributor
  I want to add entries to the glossary
  So that I can share them with other users

  Background:
    Given the following users:
      | name   | role        |
      | susan  | manager     |
      | jens   | contributor |
    And a glossary in "ja" and "en" indexed in "ja"
    And the following glossary entries:
      | user    | term_in_en    | term_in_ja     |
      | jens    | apple         | りんご         |

  Scenario: Glossary contributor successfully adds glossary entry
    Given I am logged in as "jens"
    When I add the following glossary entry:
      | Japanese          | オレンジ            |
      | English           | orange              |
      | Usage information | A fruit.            |
      | Translator notes  | need to check this  |
    Then I should see the page for "オレンジ"
    And I should see the text "オレンジ"
    And I should see the text "orange"
    And I should see the text "A fruit."
    And I should see the text "need to check this"
    And I should see a success message: "New glossary entry has been created."
    And an unapproved glossary entry "オレンジ" should exist
    And there should be 2 glossary entries

  Scenario Outline: Glossary contributor tries to add invalid glossary entry
    Given I am logged in as "jens"
    When I add the following glossary entry:
      | Japanese           | <japanese> |
      | English            | <english>  |
      | Translator notes   | <note>     |
    Then I should see the new entry page
    And I should see an error message: "There were errors in the information entered."
    And I should see the text: "<message>"
    And there should only be 1 glossary entry

    Examples:
      | japanese | english  | note | message                    |
      | りんご   | anything |      | is already in the glossary |
      |          | anything |      | can't be blank             |

  @wip
  Scenario: Glossary contributor cannot pre-approve glossary entry

  @wip
  Scenario: Glossary manager adds approved glossary entry
