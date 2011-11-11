Feature: Manage user accounts
  As an admin user
  I want to create a new user account
  So that other users can add glossary entries

  Scenario: Create new user account
    Given that I am on the homepage
    And I am logged in
    When I click "Add a new user"
    Then I should be prompted for the new user name
    And I should be prompted for the new user password

  Scenario: User already exists
  
  Scenario: Delete user account
