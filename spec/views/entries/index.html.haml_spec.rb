require 'spec_helper'

describe "entries/index.html.haml" do

  before do
    Yogoshu::Locales.set_base_languages(:en, :ja)
    assign(:base_languages, %w[en ja]) 
  end

  context "logged-out user" do
    before do
      view.stub(:logged_in?) { false }
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
        @alice = Factory(:alice)
        @entry1 = Entry.create(:user => @alice, :source_language => 'en')
        @entry2 = Entry.create(:user => @alice, :source_language => 'en')
        @entry3 = Entry.create(:user => @alice, :source_language => 'en')
        @entry1.term_in_en = "term1"
        @entry2.term_in_en = "term2"
        @entry3.term_in_en = "term3"
        @entries = [@entry1, @entry2, @entry3]
        Entry.stub(:all) { @entries }
      end

      pending "renders list of entries" do
        render
        rendered.should have_link("term1")
        rendered.should have_link("term2")
        rendered.should have_link("term3")
      end

    end

  end

end
