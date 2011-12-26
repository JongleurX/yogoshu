Feature: Login to account
  As a glossary user
  I want to login to my account
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
    Then I should be logged in as "jens"
    And I should see the homepage
    
  Scenario Outline: Invalid login
    When I fill in "User name" with "<name>"
    And I fill in "Password" with "<password>"
    And I click "Login"
    Then I should not be logged in
    And I should see the login page

    Examples:
      | name | password |
      | jens |          |
      | jens | abc      |
      | joe  | anything |
