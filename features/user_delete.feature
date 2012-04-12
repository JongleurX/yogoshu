Feature: Delete user account
  As a glossary manager
  I want to delete a user account
  So that I can reduce the number of inactive accounts

  Background:
    Given the following users:
      | name   | role         |
      | jens   | contributor  |
      | susan  | manager      |
      | yokota | manager      |
    And the following glossary entries:
      | user  | term_in_en    | term_in_ja   |
      | jens  | apple         | りんご       |

  Scenario: Glossary manager successfully deletes contributor user
    Given I am logged in as "susan"
    When I delete the user "jens"
    Then user "jens" should not exist
    And there should be only 2 users

  Scenario: Glossary manager successfully deletes manager user
    Given I am logged in as "susan"
    When I delete the user "yokota"
    Then user "yokota" should not exist
    And there should be only 2 users

  @wip
  Scenario: User accesses entry created by deleted user
    Given I am logged in as "susan"
    When I delete the user "jens"
    And I go to the show page for entry "りんご"
    Then I should see the text "りんご"
    And I should see the text "apple"
    And I should see the text "jens"

  @wip
  Scenario: Access profile page of deleted user
    Given I am logged in as "susan"
    When I delete the user "jens"
    And I go to the url for user "jens"
    Then I should see the text "has been deleted"
