require 'spec_helper'

describe "entries/index" do

  before do
    Yogoshu::Locales.set_base_languages(:ja,:en)
    Yogoshu::Locales.set_glossary_language(:ja)
    assign(:base_languages, Yogoshu::Locales.base_languages) 
    assign(:glossary_language, Yogoshu::Locales.glossary_language) 
    @alice = Factory(:user, name: "alice")
    @bob = Factory(:user, name: "bob")
  end

  context "logged-out user" do
    before do
      view.stub(:logged_in?) { false }
      view.stub(:manager?) { false }
    end

    context "with no entries" do
      before(:each) do
        assign(:entries, []) 
      end
      
      it "should have search box" do
        render
        rendered.should have_selector("form[method='get']")
        rendered.should have_selector("input[type='text'][name='search']")
      end

      it "renders an empty entry list" do
        render
        rendered.should =~ /No entries/
      end

    end

    context "with 3 entries" do

      before(:each) do
        @entry1 = Entry.create(:user => @alice, :term_in_ja => "term1")
        @entry2 = Entry.create(:user => @bob, :term_in_ja => "term2")
        @entry3 = Entry.create(:user => @alice, :term_in_ja => "term3")
        @entries = [@entry1, @entry2, @entry3]
        Entry.stub(:all) { @entries }
      end

      it "renders list of entries" do
        render
        rendered.should have_selector("a", :text => "term1")
        rendered.should have_selector("a", :text => "term2")
        rendered.should have_selector("a", :text => "term3")
      end

      it "does not render approved/unapproved status of entries" do
        render
        rendered.should_not =~ /approved/
      end

      it "does not render name of user who added entry" do
        render
        rendered.should_not =~ /bob/
      end

    end

  end

  context "logged-in user" do
    before do
      view.stub(:logged_in?) { true }
    end

    before(:each) do
      @entry1 = Entry.create(:user => @alice, :term_in_ja => "term1", :approved => false)
      @entry2 = Entry.create(:user => @bob, :term_in_ja => "term2", :approved => false)
      @entry3 = Entry.create(:user => @alice, :term_in_ja => "term3", :approved => true)
      @entries = [@entry1, @entry2, @entry3]
      Entry.stub(:all) { @entries }
    end

    context "as contributor" do
      before do
        view.stub(:manager?) { false }
        assign(:current_user, @alice)
      end

      it "renders list of entries with approved/unapproved status" do
        render
        rendered.should have_xpath("//tr[./td[contains(.,'term1')]]/td/span", :text => /^unapproved$/i)
        rendered.should have_xpath("//tr[./td[contains(.,'term2')]]/td/span", :text => /^unapproved$/i)
        rendered.should have_xpath("//tr[./td[contains(.,'term3')]]/td/span", :text => /^approved$/i)
      end

      it "renders name of user whoh added each entry" do
        render
        rendered.should have_xpath("//tr[./td[contains(.,'term1')]]/td/a", :text => "alice")
        rendered.should have_xpath("//tr[./td[contains(.,'term2')]]/td/a", :text => "bob")
        rendered.should have_xpath("//tr[./td[contains(.,'term3')]]/td/a", :text => "alice")
      end

    end

    context "as manager" do
      before do
        view.stub(:manager?) { true }
        assign(:current_user, Factory(:manager))
      end

      it "renders list of approved and unapproved entries with action buttons" do
        render
        rendered.should have_xpath("//tr[./td[contains(.,'term1')]]/td/a[@data-method='delete'][@title='destroy']")
        rendered.should have_xpath("//tr[./td[contains(.,'term1')]]/td/a[@data-method='put'][@title='approve']")
        rendered.should have_xpath("//tr[./td[contains(.,'term2')]]/td/a[@data-method='delete'][@title='destroy']")
        rendered.should have_xpath("//tr[./td[contains(.,'term2')]]/td/a[@data-method='put'][@title='approve']")
        rendered.should have_xpath("//tr[./td[contains(.,'term3')]]/td/a[@data-method='delete'][@title='destroy']")
        rendered.should have_xpath("//tr[./td[contains(.,'term3')]]/td/a[@data-method='put'][@title='unapprove']")
      end
    end

  end

end
