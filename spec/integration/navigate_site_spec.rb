require 'spec_helper'

describe "Site navigation" do

  before do
    I18n.locale = 'en'
    @entry = FactoryGirl.create(:entry)
    FactoryGirl.create(:manager)
    visit login_path
    fill_in "User name", :with => "manager_user"
    fill_in "Password", :with => "secret"
    click_on "Login"
  end

  describe "navigate to the edit page for an entry" do

    it "links to edit page from entry" do
      visit entry_path(@entry)
      click_link "Edit"
      page.should have_css("title", :text => "Edit entry")
    end

    it "links to edit page from entry index" do
      visit entries_path
      within(:xpath, "//tr[./td[contains(.,'#{@entry.term_in_glossary_language}')]]") do
        click_link "edit"
      end
      page.should have_css("title", :text => "Edit entry")
    end
  end
end
