Feature: Add user account
  As a glossary manager
  I want to add a user account
  So that a new user can add entries to the glossary

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | manager      |
    And I am logged in as "susan"

  Scenario: Successful user add
    When I add user "frank" with password "secret" and role "contributor"
    Then I should see frank's profile page
    And I should see a notice message: "User frank has been created."
    And user "frank" with password "secret" and role "contributor" should exist
    And there should be 3 users

  Scenario: User name already taken
    When I add user "jens"
    Then I should see the new user page
    And I should see an error message: "Name has already been taken" 
    And there should be only 2 users

  Scenario Outline: Invalid user info
    Given I am on the "users" page
    When I follow "Add user"
    And I fill in "<field>" with "<value>"
    And I click "Add"
    Then I should see the inline error "<error>" for "<field>"

    Examples:
      | field | value | error |
