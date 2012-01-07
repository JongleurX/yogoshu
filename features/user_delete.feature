Feature: Delete user account
  As a glossary manager
  I want to delete a user account
  So that I can reduce the number of inactive accounts

  Background:
    Given the following users:
      | name  | role         |
      | jens  | contributor  |
      | susan | manager      |

  Scenario: Glossary manager successfully deletes user
    Given I am logged in as "susan"
    When I delete the user "jens"
    Then user "jens" should not exist
    And there should be only 1 user
