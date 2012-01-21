module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given /^I am on the (.+)$/ do |page_name|
  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
end

Given /^I am on entry "([^"]*)"$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  visit entry
end

When /^I go to the (.+)$/ do |page_name|
  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
end

Then /^I should see the login page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Login")
end

Then /^I should see the homepage$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Home")
end

Then /^I should see the new entry page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Add new entry")
end

Then /^I should see the new user page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Create user")
end

Then /^I should see the entries page$/ do
  page.should have_xpath("//title", :text => "Yogoshu: Search glossary")
end

Then /^I should see an? (error|success|notice) message: "(.*)"$/ do |msg_type,message|
  page.should have_css(".#{msg_type.gsub('notice','message')}", :text => message)
end

Then /^I should see the text: "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I (should|should not) see a link to "([^"]*)"$/ do |expectation,link_text|
  (expectation == 'should') ? 
    (page.should have_link(link_text)) :
    (page.should_not have_link(link_text))
end

Then /^I (should|should not) see a link to the (.+)$/ do |expectation,page_name|
  (expectation == 'should') ? 
    (page.should have_link('', :href => eval("#{page_name.gsub(' page','').gsub(' ','_')}_path"))) :
    (page.should_not have_link('', :href => eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")))
end

Then /^I should see a navigation bar$/ do
  page.should have_selector(".topbar")
end

Then /^the navigation bar should have a link to my profile$/ do
  within '.topbar' do
    page.should have_selector('a', :href => user_path(User.current_user), :text => User.current_user.name)
  end
end

# from web_steps.rb
Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

# from web_steps.rb
Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end
