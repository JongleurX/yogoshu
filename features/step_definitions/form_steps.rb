When /^I fill in "([^"]*)" with "([^"]*)"/ do |field,value|
  fill_in(field, :with => value)
end

When /^I click "([^"]*)"/ do |link_name|
  click_on(link_name)
end

And /^I submit the form$/ do
  pending
end
