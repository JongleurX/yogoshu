When /^I search for the keywords? "([^"]*)"$/ do |keywords|
  visit homepage_path
  fill_in "search", :with => keywords
  click_on "Submit"
end

["should", "should not"].each do |condition|
  eval <<-END_RUBY
  Then /^I #{condition} see the autocomplete result "([^"]*)"$/ do |text|
    page.execute_script %Q{ $('input[data-autocomplete]').trigger("focus") }
    page.execute_script %Q{ $('input[data-autocomplete]').trigger("keydown") }
    sleep 1
    page.#{condition.gsub(' ','_')} have_css('.ui-menu-item a', :text => text)
  end
  END_RUBY
end

Then /^I should not see any search results$/ do
  page.should have_content("No entries found.")
end
