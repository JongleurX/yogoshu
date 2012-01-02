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
      | user | term_in_en | term_in_ja | approved |
      | jens | apple      | りんご     | true     |
      | jens | orange     | オレンジ   | false    |
      | jens | banana     | バナナ     | false    |

  Scenario: Glossary user finds approved entry searching in Japanese
    When I search for the keyword "りんご"
    Then I should see the entries page
    And I should see a link to "りんご"

  Scenario: Glossary user finds approved entry searching in English
    When I search for the keyword "apple"
    Then I should see the entries page
    And I should see a link to "りんご"

  Scenario: Glossary user fails to find unapproved entry
    When I search for the keyword "オレンジ"
    Then I should see the entries page
    But I should not see a link to "オレンジ"

  Scenario: Glossary user fails to find non-existent entry
    When I search for the keyword "pear"
    Then I should see the entries page
    But I should not see any search results

  Scenario: Glossary manager searches for unapproved entries
