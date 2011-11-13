Feature: Manage user accounts
  As the glossary manager
  I want to manage user accounts
  So that other users can help add entries to the glossary

  Background:
    Given a logged in administrator user

  Scenario: Create new user account
    When I try to add a new user
    Then I should be prompted for the new user name and password

  Scenario: Successful user create
    When I add a user that does not yet exist
    Then I should see the page for the newly created user
    And I should see a notice indicating that the new user has been created

  Scenario: User already exists
    When I add a user that already existss
    Then I should be told that the user already exists
    And no new user should be added

  Scenario: Delete user account
    When I delete a user
    Then I should be prompted for the user name
    And the user account should be deleted
