Given /^the following users:$/ do |table|
  table.hashes.each do |hash|
    Factory(:user, hash)
  end
end

Given /^I am logged in$/ do
  @user = Factory(:user)
  visit login_path
  fill_in('User name', :with => @user.name)
  fill_in('Password', :with => @user.password)
  click_button('Login')
end

Given /^I am logged in as "([^"]*)"$/ do |name|
  @user = User.find_by_name(name)
  visit login_path
  fill_in('User name', :with => @user.name)
  fill_in('Password', :with => @user.password)
  click_button('Login')
end

When /^I go to the list of users$/ do
  visit users_path
end

Then /^I should see "([^"]*)"$/ do |text|
  response.should have_content(text)
end

When /^I click to add a new user$/ do
  click_link "Add user"
end

Then /^I should be prompted for the new user name and password$/ do
  response.should have_field('User name')
  response.should have_field('Password')
end

When /^I add a user that does not yet exist$/ do
  fill_in('User name', :with => "alice")
  fill_in('Password', :with => "abcdef")
  click_button('Add')
end

Then /^I should see the page for the newly created user$/ do
  pending
end

Then /^I should see a notice indicating that the new user has been created$/ do
  pending
end

When /^I add a user that already exists$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be told that the user already exists$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^no new user should be added$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I delete a user$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should be prompted for the user name$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the user account should be deleted$/ do
  pending # express the regexp above with the code you wish you had
end
