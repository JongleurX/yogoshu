Feature: Manage user accounts
  As a glossary user
  I want to manage user accounts
  So that I can help add entries to the glossary

  Background:
    Given the following users:
      | name  | password | role         |
      | jens  | secret   | contributor  |
      | susan | secret   | admin        |

  Scenario: Navigation bar for logged-in users
    Given I am logged in
    When I go to any page
    Then I should see a navigation bar
    And the navigation bar should have a link to my profile
    And the navigation bar should have a link to the most recent glossary entries I have contributed

  Scenario: List users
    Given I am logged in
    When I go to the list of users
    Then I should see a link to jens' profile
    And I should see a link to susan's profile

  Scenario: Successful user create
    Given I am logged in as "susan"
    When I add a new user "frank" with password "secret"
    Then I should see frank's profile page
    And I should see a notice message: "User frank has been created."
    And user "frank" with password "secret" should exist
    And there should be 3 users

  Scenario: User already exists
    Given I am logged in as "susan"
    When I add a new user "jens"
    Then I should see the new user page
    And I should see an error message: "Name has already been taken." 
    And there should be only 2 users

  Scenario: Successful delete user account
    Given I am logged in as "susan"
    And I am on jens' profile page
    When I click "delete user"
    Then I should be asked to confirm the delete
    And jens' account should be deleted
    And there should be only 1 user
