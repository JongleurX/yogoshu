Feature: Delete glossary entry
  As a glossary contributor
  I want to delete an entry from the glossary
  So that I can keep the glossary up-to-date

  Background:
    Given the following users:
      | name   | role        |
      | susan  | manager     |
      | jens   | contributor |
    And a glossary in "ja" and "en" indexed in "ja"
    And the following glossary entries:
      | user    | term_in_en    | term_in_ja     |
      | jens    | apple         | りんご         |

  @javascript
  Scenario: Glossary contributor successfully deletes glossary entry
    Given I am logged in as "jens"
    When I delete the glossary entry "りんご"
    Then I should see the entries page
    And I should see a success message: "Entry "りんご" has been deleted."
    And there should be no glossary entries
    And debug
    And there should be no glossary entry translations
    And the glossary entry "りんご" should not exist
