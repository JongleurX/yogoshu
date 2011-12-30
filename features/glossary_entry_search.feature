Feature: Search glossary entries
  As a glossary user
  I want to find an official translation for a term
  So that I can translate a document

  Background:
    Given the following users:
      | name   | role        |
      | jens   | contributor |
      | susan  | manager     |
    And a glossary in "ja" and "en" indexed in "ja"
    And the following glossary entries:
      | user | term_in_en | term_in_ja | note                       | approved |
      | jens | apple      | りんご     | Is there a kanji for this? | true     |
      | jens | orange     | オレンジ   |                            | false    |
      | jens | banana     | バナナ     | Help translate this!       | false    |

  Scenario: Glossary user finds approved entry searching in Japanese
    Given I am on the homepage
    When I fill in "search" with "りんご"
    And I submit the form
    Then I should see the glossary entries index page
    And I should see a link to "りんご"

  Scenario: Glossary user finds approved entry searching in English

  Scenario: Glossary user fails to find unapproved entry

  Scenario: Glossary user fails to find non-existent entry

  Scenario: Glossary contributor searches for untranslated entries
