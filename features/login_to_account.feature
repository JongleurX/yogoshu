Feature: Login to account

  As a glossary user
  I want to login to my account
  So that I can add entries to the glossary

  Background:
    Given the following users:
      | name   | password |
      | jens   | secret   |
    And that I am on the login page

  Scenario: Valid name and correct password
    When I fill in the name "jens"
    And I fill in the password "secret"
    Then I should see the homepage
    And I should be logged in
    
  Scenario: Valid name but incorrect password
    When I fill in the name "jens"
    And I fill in the password "abc"
    Then I should see the login page
    And I should not be logged in
