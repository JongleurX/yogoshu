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

