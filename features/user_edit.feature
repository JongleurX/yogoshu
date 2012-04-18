Feature: Edit user account
  As a glossary manager
  I want to edit a user account
  So that I can keep user info up-to-date

  Background:
    Given the following users:
      | name   | role         |
      | jens   | contributor  |
      | susan  | manager      |
      | yokota | manager      |

  Scenario: Glossary manager successfully edits contributor password
    Given I am logged in as "susan"
    And I am on the edit page for user "jens"
    When I fill in "Password" with "newpassword"
    And I fill in "Confirm password" with "newpassword"
    And I click "Save"
    Then I should see the page for user "jens"
    And I should see a success message: "User jens has been updated."
    And the password of user "jens" should be "newpassword"

  Scenario: Glossary manager successfully edits contributor name
    Given I am logged in as "susan"
    And I am on the edit page for user "jens"
    When I fill in "User name" with "frank"
    And I click "Save"
    Then I should see the page for user "frank"
    And I should see a success message: "User frank has been updated."

  Scenario Outline: Invalid edit
    Given I am logged in as "susan"
    And I am on the edit page for user "jens"
    When I fill in "<field>" with "<value>"
    And I click "Save"
    Then I should see the edit page for user "jens"
    And I should see an error message: "There were errors in the information entered."
    And I should see the error "<message>" on field "<field>"

    Examples:
      | field     | value  | message    |
      | user_name | abc-22 | is invalid |
