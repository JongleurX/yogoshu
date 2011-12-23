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

When /^I go to the homepage$/ do
  visit homepage_path
end


When /^I go to the list of users$/ do
  When "I go to the homepage"
  click_link('Users')
end

Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see a link to (.+)'s? profile$/ do |name|
  @user = User.find_by_name(name)
  page.should have_link(@user.name, :href => user_path(@user))
end

When %{I add a new user "$name" with password "$password"} do |name,password|
  When %{I go to the list of users}
  And %{I click "Add user"}
  And %{I fill in "User name" with "#{name}"}
  And %{I fill in "Password" with "#{password || "secret"}"}
  And %{I fill in "Confirm password" with "#{password || "secret"}"}
  And %{I click "Submit"}
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
  page.should have_css('legend',:content => "Add a new user")
end

Given /^I am on (.+)'s? profile page$/ do |name|
  @user = User.find_by_name(name)
  visit user_path(@user)
end

Given /^I am on the login page$/ do
  visit login_path
end

When /^I fill in the name "([^"]*)"$/ do |name|
  fill_in(:name, :with => name)
end

When /^I fill in the password "([^"]*)"$/ do |password|
  fill_in(:password, :with => password)
end

Then /^I should be logged in as "([^"]*)"$/ do |name|
  @user = User.find_by_name(name)
  page.should have_link('Profile', :href => user_path(@user))
end

Then /^I should not be logged in$/ do
  page.should_not have_link('Profile')
end

Then /^I should see the homepage$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Home")
end

Then /^I should see the login page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Login")
end
