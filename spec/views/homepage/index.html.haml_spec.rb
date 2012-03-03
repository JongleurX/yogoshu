require 'spec_helper'

describe "homepage/index" do

  context "logged-out user" do
    before do
      view.stub(:logged_in?) { false }
    end

    describe "search box" do
      it "should show the search input field" do
        render
        rendered.should have_selector("form input[@type='text'][@name='search']")
      end
      it "should show language checkboxes"
      it "should not show status checkboxes"
    end
  end

  context "logged-in user" do
    before do
      view.stub(:logged_in?) { true }
    end
  
    describe "search box" do
      it "should show the search box" do
        render
        rendered.should =~ /Search glossary/
      end
      it "should show language checkboxes"
      it "should show status checkboxes"
    end

  end

end
