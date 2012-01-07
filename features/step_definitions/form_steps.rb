When /^I fill in "([^"]*)" with "([^"]*)"/ do |field,value|
  fill_in(field, :with => value)
end

When /^I click "([^"]*)"/ do |link_name|
  click_on(link_name)
end

Then /^I should see the error "([^"]*)" on field "([^"]*)"/ do |error,field|
  within '.new_user' do
    div = find(:xpath, "//div[./input[@id=\"#{field}\"]]")
    div.should have_content(error)
  end
end

