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

  @javascript @wip
  Scenario: Autocomplete search
    When I go to the homepage
    And I fill in "search" with "ap"
    And I choose "apple" in the autocomplete list
    Then the "search" field should contain "apple"

  Scenario Outline: Glossary user finds entry
    When I search for the keyword "<keyword>"
    Then I should see the entries page
    And I should see a link to "<link_text>"

    Examples:
      | keyword | link_text |
      | りんご  | りんご    |
      | りん    | りんご    |
      | apple   | りんご    |
      | APPLE   | りんご    |
      | appL    | りんご    |
  
  Scenario Outline: Glossary user fails to find entry
    When I search for the keyword "<keyword>"
    Then I should see the entries page
    But I should not see a link to "<link_text>"

    Examples:
      | keyword   | link_text |
      | オレンジ  | オレンジ  |
      | orange    | オレンジ  |
      | バナナ    | バナナ    |
  
  Scenario: Glossary user fails to find non-existent entry
    When I search for the keyword "pear"
    Then I should see the entries page
    But I should not see any search results

  Scenario: Glossary contributor searches for unapproved entries
    Given I am logged in as "jens"
    When I search for the keyword "orange"
    Then I should see the entries page
    And I should see a link to "オレンジ"
