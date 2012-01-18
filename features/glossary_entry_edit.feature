Feature: Edit glossary entry
  As a glossary contributor
  I want to edit glossary entries
  So that I can improve the quality of the glossary

  Background: 
    Given the following users:
      | name   | role        |
      | susan  | manager     |
      | jens   | contributor |
    And a glossary in "ja" and "en" indexed in "ja"
    And the following glossary entries:
      | user_id | term_in_en    | term_in_ja     |
      | jens    | apple         | りんご         |

  @javascript @wip
  Scenario Outline: Glossary contributor edits glossary entry
    Given I am logged in as "jens"
    And I am on the page of entry "りんご"
    When I edit "<term>" and replace it with "<value>"
    And I click "Save"
    Then I should see the success message "<message>"

    Examples:
      | term  | value | message |
      | apple | newvalue | abc |
