Feature: Delete user account
  As a glossary manager
  I want to delete a user account
  So that I can reduce the number of inactive accounts

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | manager      |
    And I am logged in as "susan"

  @wip
  Scenario: Successful user delete
    Given I am on jens' profile page
    When I click "delete user"
    Then I should be asked to confirm the delete
    And jens' account should be deleted
    And there should be only 1 user
