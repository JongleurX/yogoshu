Feature: Navigate glossary site
  As a glossary user
  I want to navigate the glossary site
  So that I can easily find glossary entries

  Background:
    Given the following users:
      | name |
      | jens |

  Scenario Outline: Navigation bar for logged-in users
    Given I am logged in as "jens"
    When I go to the <page>
    Then I should see a navigation bar
    And the navigation bar should have a link to my profile

    Examples:
      | page           |
      | homepage       |
      | login page     |
      | users page     |
      | entries page   |
