When /^I search for the keywords? "([^"]*)"$/ do |keywords|
  visit homepage_path
  fill_in "search", :with => keywords
  click_on "Submit"
end

Then /^I should not see any search results$/ do
  page.should have_content("No entries found.")
end
