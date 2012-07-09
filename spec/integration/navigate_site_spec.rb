require 'spec_helper'

describe "Site navigation" do

  def login(username, password)
    visit login_path
    fill_in "User name", :with => username
    fill_in "Password", :with => password
    click_on "Login"
  end

  before do
    I18n.locale = 'en'
    @entry = FactoryGirl.create(:entry)
    FactoryGirl.create(:manager)
  end

  describe "navigate to the edit page for an entry" do

    it "links to edit page from entry" do
      login("manager_user", "secret")
      visit entry_path(@entry)
      click_link "Edit"
      page.should have_css("title", :text => /Edit entry/)
    end

    it "links to edit page from entry index" do
      login("manager_user", "secret")
      visit entries_path
      within(:xpath, "//tr[./td[contains(.,'#{@entry.term_in_glossary_language}')]]") do
        click_link "edit"
      end
      page.should have_css("title", :text => /Edit entry/)
    end
  end
end
