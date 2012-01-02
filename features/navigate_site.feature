Feature: Navigate glossary site
  As a glossary user
  I want to navigate the glossary site
  So that I can easily find glossary entries

  Background:
    Given the following users:
      | name  | role        |
      | jens  | contributor |
      | susan | manager     |

  Scenario Outline: Navigation bar for logged-in users
    Given I am logged in as "<user>"
    When I go to the <page>
    Then I should see a navigation bar
    And the navigation bar should have a link to my profile

    Examples:
      | user  | page           |
      | jens  | homepage       |
      | jens  | login page     |
      | jens  | users page     |
      | jens  | entries page   |
      | jens  | new_entry page |
      | susan | new_user page  |
