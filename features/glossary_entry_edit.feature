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
      | user    | term_in_en    | term_in_ja | note            |
      | jens    | orange        | りんご     | a healthy fruit |
      | susan   | pear          | ナシ       |                 |

  Scenario: Glossary contributor edits target language term
    Given I am logged in as "jens"
    And I am on the edit page for entry "りんご"
    When I fill in "English" with "apple"
    And I click "Save"
    Then I should see the page for "りんご"
    And I should see the text "りんご"
    And I should see the text "apple"
    And I should not see the text "orange"
    And I should see a success message: "Entry "りんご" has been updated."

  Scenario: Glossary contributor edits glossary language term
    Given I am logged in as "jens"
    And I am on the edit page for entry "りんご"
    When I fill in "Japanese" with "オレンジ"
    And I click "Save"
    Then I should see the page for "オレンジ"
    And I should see the text "オレンジ"
    And I should see the text "orange"
    And I should not see the text "りんご"
    And I should see a success message: "Entry "オレンジ" has been updated."

  Scenario: Glossary contributor tries to edit other user's entry
    Given I am logged in as "jens"
    When I go to the edit page for entry "ナシ"
    Then I should see the page for "ナシ"
    And I should see an error message: "You are not authorized to edit this entry."

  Scenario: Glossary manager edits other user's entry

  Scenario Outline: Invalid edit
    Given I am logged in as "jens"
    And I am on the edit page for entry "りんご"
    When I fill in "Japanese" with ""
    Then I should see the page for "りんご"
    And I should see the error message: "Invalid edit."
    And I should see the error "can't be blank" on field "Japanese"
