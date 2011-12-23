Feature: Manage user accounts
  As a glossary manager
  I want to manage user accounts
  So that I can help others add entries to the glossary

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | manager      |
    And I am logged in as "susan"

  Scenario: List users
    When I go to the list of users
    Then I should see a link to jens' profile
    And I should see a link to susan's profile
