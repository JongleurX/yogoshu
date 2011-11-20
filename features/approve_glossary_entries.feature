Feature: Approve glossary entries
  As a glossary manager
  I want to approve glossary entries
  So that I can share them with all glossary useres

  Background:
    Given the following users:
      | name   | role        |
      | susan  | manager     |
      | yokota | manager     |
      | jens   | contributor |
    And a glossary in Japanese and English indexed in Japanese
    And the following glossary entries:
      | English | Japanese | approved? | approved_by |
      | apple   | りんご   | yes       | yokota      |
      | orange  | オレンジ | no        |             |
      | banana  | バナナ   | yes       | susan       |

  Scenario: Glossary manager approves translated glossary entry
    
  Scenario: Glossary manager tries to approve untranslated glossary entry
    
  Scenario: Glossary manager tries to unapprove glossary entry that was approved by another manager
