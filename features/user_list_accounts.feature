Feature: List user accounts
  As a glossary manager
  I want to list all user accounts
  So that I can easily review existing users

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | manager      |

  Scenario: List users
    Given I am logged in as "susan" with password "secret"
    When I go to the users page
    Then I should see a link to jens' profile
    And I should see a link to susan's profile
    And I should see a link to the new user page
