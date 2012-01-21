Given /^a glossary in "([^"]*)"(?: and "([^"]*)")+ indexed in "([^"]*)"$/ do |*langs, glossary_language|
  Yogoshu::Locales.set_base_languages(*langs.map(&:to_sym))
  Yogoshu::Locales.set_glossary_language(glossary_language.to_sym)
end

Given /^the following glossary entr(?:y|ies):$/ do |table|
  table.hashes.each do |hash|
    u = User.find_by_name(hash.delete("user"))
    Factory(:entry, u.nil? ? hash : hash.merge(:user => u))
  end
end

When /^I add the following glossary entry:$/ do |table|
  visit homepage_path
  click_link('Add Entry')
  table.rows_hash.each do |field,value|
    fill_in(field, :with => value)
  end
  click_button('Add entry')
end

When /^I edit "([^"]*)" and replace it with "([^"]*)"$/ do |old_value,new_value|
  element = find(:xpath, "//span[@class='best_in_place']", :text => old_value)
end

When /^I (approve|unapprove) the glossary entry "([^"]*)"$/ do |action, term|
  visit entries_path
  within('table') do
    row = find(:xpath, "//tr[./td[contains(.,\"#{term}\")]]")
    row.find("a[@title=\"#{action}\"]").click
  end
end

Then /^(?:the|a|an) (approved|unapproved|) ?glossary entry "([^"]*)" should exist$/ do |status,term|
  entry = Entry.find_by_term_in_glossary_language(term)
  entry.should_not be_nil
  entry.approved?.should == (status == "approved") unless status.nil?
end

Then %{I should see the page for "$term"} do |term|
  page.should have_xpath("//title", :text => "Yogoshu: #{term}")
end

Then /^there should (?:only |)be ([\d]+) glossary entr(?:y|ies)/ do |n|
  Entry.count.should eql(n.to_i)
end

Then /^the glossary entry "([^"]*)" should be (approved|unapproved)$/ do |term, status|
  Entry.find_by_term_in_glossary_language(term).approved?.should == (status == "approved")
end
