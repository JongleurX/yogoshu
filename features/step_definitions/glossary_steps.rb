Given /^a glossary in "([^"]*)"(?: and "([^"]*)")+ indexed in "([^"]*)"$/ do |*langs, glossary_language|
  Yogoshu::Locales.set_base_languages(*langs.map(&:to_sym))
  Yogoshu::Locales.set_glossary_language(glossary_language.to_sym)
end

Given /^the following glossary entr(?:y|ies):$/ do |table|
  table.hashes.each do |hash|
    Factory(:entry, hash)
  end
end

When /^I add the following glossary entr(?:y|ies):$/ do |table|
  visit homepage_path
  click_link('Add Entry')
  table.hashes.each do |hash|
    hash.keys.each do |key|
      fill_in('entry_' + key, :with => hash[key])
    end
    click_button('Add entry')
  end
end

Then /^(?:the|a|an) (approved|unapproved|) ?glossary entry "([^"]*)" should exist/ do |status,term|
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
