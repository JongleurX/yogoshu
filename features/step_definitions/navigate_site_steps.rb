Given /^I am on the login page$/ do
  visit login_path  
end

When /^I go to the homepage$/ do
  visit homepage_path
end

When /^I go to the list of users$/ do
  visit homepage_path
  click_link('Users')
end

Then /^I should see the homepage$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Home")
end

Then /^I should see the login page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Login")
end

#Then /^I should see a navigation bar$/ do
#  page.should have_selector(".nav")
#end

#Then /^the navigation bar should have a link to my profile$/ do
#  within '.nav' do
#    page.should have_selector('a', :href => user_path(@user), :text => "Profile")
#  end
#end

#Then /^the navigation bar should have a link to the most recent glossary entries I have added$/ do
#  pending
##  within 'nav' do
##    page.should have_selector('a', :href => user_path(@current_user), :content => "Profile")
##  end
#end
