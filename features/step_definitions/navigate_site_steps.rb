Then /^I should see a navigation bar$/ do
  page.should have_selector("nav")
end

Then /^the navigation bar should have a link to my profile$/ do
  within 'nav' do
    page.should have_selector('a', :href => user_path(@current_user), :content => "Profile")
  end
end

Then /^the navigation bar should have a link to the most recent glossary entries I have added$/ do
  pending
#  within 'nav' do
#    page.should have_selector('a', :href => user_path(@current_user), :content => "Profile")
#  end
end

