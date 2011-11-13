Given /^a logged in administrator user$/ do
  @admin_user = User.create!(:name => "admin", :password => "abcde", :status => :admin)
  visit login_path
  fill_in('User name', :with => @admin_user.name)
  fill_in('Password', :with => @admin_user.password)
  click_button('Login')
end

When /^I try to add a new user$/ do
  visit homepage_path
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
