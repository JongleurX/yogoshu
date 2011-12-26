Feature: Add glossary entry
  As a glossary contributor
  I want to add entries to the glossary
  So that everyone maintains consistent terminology

  Background:
    Given the following users:
      | name   | role        |
      | susan  | manager     |
      | jens   | contributor |
      | yunike | contributor |
    And a glossary in "ja" and "en" indexed in "ja"
    And the following glossary entries:
      | user_id | term_in_en    | term_in_ja     |
      | jens    | apple         | りんご         |

  Scenario: Glossary contributor successfully adds glossary entry with translation
    Given I am logged in as "jens"
    When I add the following glossary entry:
      | term_in_ja | term_in_en |
      | オレンジ   | orange     |
    Then the glossary entry "オレンジ" should exist
    And I should see the page for "オレンジ"
    #    And I should see a notice: "Glossary entry has been created."
    #And an unapproved Japanese glossary entry "オレンジ" with English translation "orange" should exist
    And there should be 2 glossary entries

  @wip
  Scenario: Glossary contributor successfully adds glossary entry without translation
    Given that I am logged in as "jens"
    And that I am on the homepage
    When I try to add a Japanese glossary entry "オレンジ" without a translation
    Then I should see the page for "オレンジ"
    And I should see a notice: "Glossary entry has been created."
    And an unapproved untranslated Japanese glossary entry "オレンジ" should exist
    And there should be 2 glossary entries

  @wip
  Scenario: Glossary contributor cannot pre-approve glossary entry
    Given that I am logged in as "jens"
    And that I am on the homepage
    When I click the link to add a glossary entry
    Then I should not see the checkbox to pre-approve the entry

  @wip
  Scenario: Glossary manager adds approved glossary entry
    Given that I am logged in as "susan"
    And that I am on the homepage
    When I try to add a pre-approved Japanese glossary entry "オレンジ" with English translation "orange"
    Then I should see the page for "オレンジ"
    And I should see a notice: "Glossary entry has been created."
    And an approved Japanese glossary entry "オレンジ" with English translation "orange" should exist
    And there should be 2 glossary entries

  @wip
  Scenario: Glossary contributor tries to add entry that already exists
    Given that I am logged in as "jens"
    And that I am on the homepage
    When I try to add an unapproved Japanese glossary entry "りんご" with English translation "apple"
    Then I should see the glossary page for "りんご"
    And I should see a notice: "Glossary entry already exists."
    And there should only be 1 glossary entry

  Scenario: Glossary contributor tries to add entry whose Japanese matches existing glossary entry

  Scenario: Glossary contributor tries to add entry whose English matches existing glossary entry
