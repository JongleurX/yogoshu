Feature: Navigate glossary site
  As a glossary user
  I want to navigate the glossary site
  So that I can easily find glossary entries

  Scenario: Navigation bar for logged-in users
    Given I am logged in
    When I go to the homepage
    Then I should see a navigation bar
    And the navigation bar should have a link to my profile
    And the navigation bar should have a link to the most recent glossary entries I have added
