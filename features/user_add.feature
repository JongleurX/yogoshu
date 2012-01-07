Feature: Add user account
  As a glossary manager
  I want to add a user account
  So that a new user can add entries to the glossary

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | manager      |
    And I am logged in as "susan" with password "secret"

  Scenario: Glossary manager successfully adds new user
    When I add the following user:
      | User name         | frank        |
      | Role              | contributor  |
      | Password          | secret       |
      | Confirm password  | secret       |
    Then I should see the profile page for "frank"
    And I should see a success message: "User frank has been created."
    And there should be 3 users

  Scenario Outline: Glossary manager tries to add invalid user
    When I add the following user:
      | User name         | <name>                  |
      | Role              | <role>                  |
      | Password          | <password>              |
      | Confirm password  | <password_confirmation> |
    Then I should see the new user page
    And I should see an error message: "There were errors in the information entered."
    And I should see the error "<error>" on field "<field>"
    And there should be only 2 users

    Examples:
      | name  | role        | password | password_confirmation | error                      | field         |
      | zz    | contributor | secret   | secret                | is too short               | user_name     |
      | '''-* | contributor | secret   | secret                | is invalid                 | user_name     |
      | jens  | contributor | secret   | secret                | has already been taken     | user_name     |
      | frank | contributor | secret   | somethingelse         | doesn't match confirmation | user_password |
      | frank | contributor | abc      | abc                   | is too short               | user_password |
