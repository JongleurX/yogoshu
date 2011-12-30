Given /^I am on the ([^\s]*)(?: page|)$/ do |page|
  visit eval("#{page}_path")
end

When /^I go to the ([^\s]*)(?: page|)$/ do |page|
  visit eval("#{page}_path")
end

Then /^I should see the homepage$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Home")
end

Then /^I should see the login page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Login")
end

Then /^I should see the new glossary entry page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Add new entry")
end

Then /^I should see the glossary entries index page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Search glossary")
end

Then /^I should see an? (error|success) message: "(.*)"$/ do |msg_type,message|
  page.should have_css(".#{msg_type}", :text => message)
end

Then /^I should see the text: "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^ I should see a link to "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end

Then /^I should see a navigation bar$/ do
  page.should have_selector(".topbar")
end

Then /^the navigation bar should have a link to my profile$/ do
  within '.topbar' do
    page.should have_selector('a', :href => user_path(User.current_user), :text => User.current_user.name)
  end
end
