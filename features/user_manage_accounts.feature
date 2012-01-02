Feature: Manage user accounts
  As a glossary manager
  I want to manage user accounts
  So that I can help others add entries to the glossary

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | manager      |
    And I am logged in as "susan" with password "secret"

  Scenario: List users
    When I go to the users page
    Then I should see a link to jens' profile
    And I should see a link to susan's profile
    And I should see a link to the new user page

  Scenario: Add a valid new user
    When I add a new user with:
      | User name         | junichi      |
      | Role              | contributor  |
      | Password          | secret       |
      | Confirm password  | secret       |
    Then I should see the profile page for "junichi"
    And there should be 3 users

  Scenario: Delete a user
