Given /^the following users:$/ do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:user, hash)
  end
end

Given /^I am logged in as "([^"]*)"(?: with password "([^"]*)"|)$/ do |name, password|
  visit login_path
  fill_in('User name', :with => name)
  fill_in('Password', :with => (password || "foobar") )
  click_on('Login')
end

When /^I add the following user:$/ do |table|
  visit new_user_path
  role = table.rows_hash.delete('Role')
  table.rows_hash.each do |field,value|
   fill_in(field, :with => value)
  end
  select(role.capitalize, :from => 'Role')
  click_on("Create")
end

When /^I (delete) the user "([^"]*)"$/ do |action,username|
  visit users_path
  within('table') do
    row = find(:xpath, "//tr[./td[contains(.,\"#{username}\")]]")
    row.find('a', :text => action).click
  end
end

When /^I confirm the delete$/ do
  pending
end

Then /^I should be logged in as "([^"]*)"$/ do |name|
  @user = User.find_by_name(name)
  page.should have_link('Profile', :href => user_path(@user))
end

Then /^I should (?:not be logged in|be logged out)$/ do
  page.should_not have_link('Profile')
end

Then /^I should see a link to (.+)'s? profile$/ do |name|
  @user = User.find_by_name(name)
  page.should have_link(@user.name, :href => user_path(@user))
end

Then /^I should see the profile page for "([^"]*)"$/ do |name|
  page.should have_xpath('//title', :text => "Yogoshu: #{name}")
end

Then /^there should be (?:only |)(\d+) users?$/ do |count|
  User.count.should == count.to_i
end

Then /^user "([^"]+)" should exist$/ do |name|
  User.find_by_name(name).should_not be_nil
end

Then /^user "([^"]+)" should not exist$/ do |name|
  User.find_by_name(name).should be_nil
end
