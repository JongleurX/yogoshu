Given /^the following users:$/ do |table|
  table.hashes.each do |hash|
    Factory(:user, hash)
  end
end

Given /^(?:that |)I am logged in$/ do
  @user = Factory(:user)
  visit login_path
  fill_in('User name', :with => @user.name)
  fill_in('Password', :with => @user.password)
  click_button('Login')
end

When /^I go to any page$/ do
  pending
end

Then /^I should see a navigation bar$/ do
  pending
end

Then /^the navigation bar should have a link to my profile$/ do
  pending
end

Then /^the navigation bar should have a link to the most recent glossary entries I have contributed$/ do
  pending
end

Given /^(?:that |)I am logged in as "([^"]*)"$/ do |name|
  @user = User.find_by_name(name)
  visit login_path
  fill_in('User name', :with => @user.name)
  fill_in('Password', :with => @user.password)
  click_button('Login')
end

When /^I go to the list of users$/ do
  visit homepage_path
  click_link('Users')
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see a link to (.+)'s? profile$/ do |name|
  @user = User.find_by_name(name)
  page.should have_link(@user.name, :href => user_path(@user))
end

When /^I add a new user "([^"]*)"(?: with password "|)([^"]*)(?:"|)$/ do |name,password|
  visit homepage_path
  click_link "Add user"
  fill_in('User name', :with => name)
  fill_in('Password', :with => password || "secret")
  click_button('Submit')
end

Then /^I should see (.+)'s? profile page$/ do |name|
  @user = User.find_by_name(name)
  @user.should_not be_nil
  uri = URI.parse(current_url)
  uri.path.should == user_path(@user)
end

Then /^I should see an? (error|notice) message: "([^"]*)"$/ do |msg_type,message|
  page.should have_css(".#{msg_type}", :text => message)
end

Then /^user "([^"]*)" with password "([^"]*)" should exist$/ do |name,password|
  @user = User.find_by_name(name)
  @user.should_not be_nil
  @user.authenticated?(password).should == true
end

Then /^there should be (?:only |)(\d+) users$/ do |count|
  User.count.should == count.to_i
end

Then /^I should see the new user page$/ do
  page.should have_css('h1',:content => "Add a new user")
end

Given /^I am on (.+)'s? profile page$/ do |name|
  @user = User.find_by_name(name)
  visit user_path(@user)
end

When /^I click "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^I should be asked to confirm the delete$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^(.+)'s? account should be deleted$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^there should be only (\d+) user$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
