Feature: Approve glossary entries
  As a glossary manager
  I want to approve glossary entries
  So that I can share them with all glossary users

  Background:
    Given the following users:
      | name   | role        |
      | susan  | manager     |
      | jens   | contributor |
    And a glossary in "ja" and "en" indexed in "ja"
    And the following glossary entries:
      | user    | term_in_en | term_in_ja | approved  |
      | susan   | apple      | りんご     | true      |
      | jens    | orange     | オレンジ   | false     |
      | jens    | banana     | バナナ     | true      |

  Scenario: Glossary manager approves glossary entry from search results page
    Given I am logged in as "susan"
    And I search for the keyword "オレンジ"
    When I click the thumbs up icon in the row for glossary entry "オレンジ"
    Then I should see the entries page
    And I should see a success message: "Entry "オレンジ" has been approved."
    And the glossary entry "オレンジ" should be approved

  Scenario: Glossary manager unapproves glossary entry from search results page
    Given I am logged in as "susan"
    And I search for the keyword "りんご"
    When I click the thumbs down icon in the row for glossary entry "りんご"
    Then I should see the entries page
    And I should see a success message: "Entry "りんご" has been unapproved."
    And the glossary entry "りんご" should be unapproved
    
  Scenario: Glossary manager approves glossary entry from entry page
    Given I am logged in as "susan"
    And I am on entry "オレンジ"
    When I click "Approve"
    Then I should see a success message: "Entry "オレンジ" has been approved."
    And the glossary entry "オレンジ" should be approved

  Scenario: Glossary manager unapproves glossary entry from entry page
    Given I am logged in as "susan"
    And I am on entry "りんご"
    When I click "Unapprove"
    Then I should see a success message: "Entry "りんご" has been unapproved."
    And the glossary entry "りんご" should be unapproved

  @wip
  Scenario: Glossary manager tries to unapprove glossary entry that was approved by another manager
