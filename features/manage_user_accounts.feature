Feature: Manage user accounts
  As a glossary user
  I want to manage user accounts
  So that I can help add entries to the glossary

  Background:
    Given the following users:
      | name  | password | role  |
      | jens  | secret   | user  |
      | susan | secret   | admin |

  Scenario: List users
    Given I am logged in as "jens"
    When I go to the list of users
    Then I should see "jens"
    And I should see "susan"

  Scenario: Successful user create
    Given I am logged in as "susan"
    And I am on the homepage
    When I follow "Add a new user"
    And I fill in the name "frank" and a password
    And I click submit
    Then I should see frank's profile page
    And I should be notified that a new user "frank" has been created
    And there should be 3 users

  Scenario: User already exists
    Given I am logged in as "susan"
    And I am on the homepage
    When I follow "Add a new user"
    And I fill in the name "jens" and a password
    And I click submit
    Then I should see jens' profile page
    And I should see a notice that the user "jens" already exists
    And there should be only 2 users

  Scenario: Successful delete user account
    Given I am logged in as "susan"
    And I am on jens' profile page
    When I click "delete user"
    Then I should be asked to confirm the delete
    And jens' account should be deleted
    And there should be only 1 user
