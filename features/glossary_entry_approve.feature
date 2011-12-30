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

  Scenario: Glossary manager approves glossary entry
    Given I am logged in as "susan"
    When I approve the glossary entry "オレンジ"
    Then I should see the glossary entries index page
    And I should see a success message: "Entry "オレンジ" has been updated."
    And the glossary entry "オレンジ" should be approved

  Scenario: Glossary manager unapproves glossary entry
    Given I am logged in as "susan"
    When I unapprove the glossary entry "りんご"
    Then I should see the glossary entries index page
    And I should see a success message: "Entry "りんご" has been updated."
    And the glossary entry "りんご" should be unapproved
    
  @wip
  Scenario: Glossary manager tries to unapprove glossary entry that was approved by another manager
