Feature: Login to (and logout of) account
  As a glossary user
  I want to login to (and logout of) my account
  So that I can add entries to the glossary

  Background:
    Given the following users:
      | name   | password |
      | jens   | secret   |
    And I am on the login page

  Scenario: Valid login
    When I fill in "User name" with "jens"
    And I fill in "Password" with "secret"
    And I click "Login"
    Then I should see the entries page
    And I should see a notice message: "You've successfully logged in. Welcome back jens!"
    And I should be logged in as "jens"
    
  Scenario Outline: Invalid login
    When I fill in "User name" with "<name>"
    And I fill in "Password" with "<password>"
    And I click "Login"
    Then I should see the login page
    And I should see an error message: "Username or password incorrect. Please try again."
    And I should not be logged in

    Examples:
      | name | password |
      | jens |          |
      | jens | abc      |
      | joe  | anything |

  Scenario: Successful logout
    Given I am logged in as "jens" with password "secret"
    When I click "Logout"
    Then I should see the entries page
    And I should see a notice message: "You've successfully logged out."
    And I should be logged out
