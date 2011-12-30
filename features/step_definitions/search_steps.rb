When /^I search for the keywords? "([^"]*)"$/ do |keywords|
  When %{I go to the homepage}
  And %{I fill in "search" with "$keywords"}
end
