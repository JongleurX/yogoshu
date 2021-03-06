module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given /^I am on the (.+page)$/ do |page_name|
  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
end

Given /^I am on entry "([^"]*)"$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  visit entry_path(entry)
end

Given /^I am on the edit page for entry "([^"]*)"$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  visit edit_entry_path(entry)
end

Given /^I am on the edit page for user "([^"]*)"$/ do |name|
  user = User.find_by_name(name)
  visit edit_user_path(user)
end

When /^I go to the (.+page)$/ do |page_name|
  visit eval("#{page_name.gsub(' page','').gsub(' ','_')}_path")
end

When /^I go to the show page for entry "([^"]*)"$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  visit entry_path(entry)
end

When /^I go to the edit page for entry "([^"]*)"$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  visit edit_entry_path(entry)
end

When /^I go to the url for user "([^"]*)"$/ do |name|
  visit '/users/' + name
end

When /^I click the link to (edit|delete) user "([^"]*)"$/ do |action, username|
  within('table') do
    row = find(:xpath, "//tr[./td[contains(.,\"#{username}\")]]")
    row.find('a', :text => action).click
  end
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

Then %{I should see the page for "$term"} do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  page.should have_xpath("//title", :text => "Yogoshu: #{term}")
end

Then %{I should see the page for user "$name"} do |name|
  user = User.find_by_name(name)
  page.should have_xpath("//title", :text => "Yogoshu: #{name}")
end

Then %{I should see the edit page for user "$name"} do |name|
  user = User.find_by_name(name)
  page.should have_xpath("//title", :text => "Edit user: #{name}")
end

Then /^I should see an? (error|success|notice) message: "(.*)"$/ do |msg_type,message|
  page.should have_css(".alert-#{msg_type.gsub('notice','message')}", :text => message)
end

Then /^I (should|should not) see the text:? "([^"]*)"$/ do |expectation,text|
  page.send(expectation.gsub(' ','_'),have_content(text))
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
  page.should have_selector(".navbar")
end

Then /^the navigation bar should have a link to my profile$/ do
  within '.navbar' do
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
