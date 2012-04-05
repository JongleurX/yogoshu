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

When /^I delete the glossary entry "([^"]*)"$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  visit entry_path(entry)
  handle_js_confirm do
    click_link('Delete')
  end
end

When /^I click the thumbs (up|down) icon in the row for glossary entry "([^"]*)"$/ do |dir, term|
  within('table') do
    row = find(:xpath, "//tr[./td[contains(.,\"#{term}\")]]")
    action = (dir == "up") ? "approve" : "unapprove"
    row.find("a[@title=\"#{action}\"]").click
  end
end

Then /^(?:the|a|an) (approved|unapproved|) ?glossary entry "([^"]*)" should exist$/ do |status,term|
  entry = Entry.find_by_term_in_glossary_language(term)
  entry.should_not be_nil
  entry.approved?.should == (status == "approved") unless status.nil?
end

Then /^the glossary entry "([^"]*)" should not exist$/ do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  entry.should be_nil
end

Then %{I should see the page for "$term"} do |term|
  entry = Entry.find_by_term_in_glossary_language(term)
  page.should have_xpath("//title", :text => "Yogoshu: #{term}")
end

Then /^there should (?:only |)be ([\d]+) glossary entr(?:y|ies)/ do |n|
  Entry.count.should eql(n.to_i)
end

Then /^there should be no glossary entries$/ do
  Entry.count.should eql(0)
end

# to catch bug #17: https://github.com/shioyama/yogoshu/issues/17
Then /^there should be no glossary entry translations$/ do
  Entry::Translation.count.should eql(0)
end

Then /^the glossary entry "([^"]*)" should be (approved|unapproved)$/ do |term, status|
  Entry.find_by_term_in_glossary_language(term).approved?.should == (status == "approved")
end
