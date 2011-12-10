# -*- coding: utf-8 -*-
require 'spec_helper'

describe Entry do

  before do
    I18n.locale = 'en'
    Globalize.locale = 'en'
    Yogoshu::Locales.set_base_languages(:ja, :en)
    Yogoshu::Locales.set_glossary_language(:ja)
  end

  describe "validation with factory" do
    
    # factory is not validating so for now using this workaround
    before(:each) do
      @entry = Entry.new(:user => Factory(:user)) 
      @entry.term_in_ja = "term"
    end

    after(:each) do
      @entry.destroy
    end

    pending "should be valid created by factory" do
      @entry_factory = Factory(:entry_ja)
      @entry_factory.should be_valid
    end

    subject { @entry }

    it "should be valid" do
      should be_valid
    end

    it "should not be valid without a source language term" do
      Globalize.with_locale(:ja) do
        subject.term = nil
      end
      should_not be_valid
    end

    it "should be invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

    it "should be invalid if not unique in source language" do
      Factory(:entry_ja, :term_in_ja => "りんご")
      subject.term_in_ja = "りんご"
      should_not be_valid
    end
    
  end

  describe "dynamic finders for translated attributes" do

    describe "#responds_to?" do

      it "returns true for dynamic finders with postfix in base_languages or source_language" do
        Entry.respond_to?(:find_by_term_in_en).should == true
        Entry.respond_to?(:find_by_term_in_ja).should == true
        Entry.respond_to?(:find_by_term_in_source_language).should == true
        Entry.respond_to?(:find_by_term_in_glossary_language).should == true
      end

      it "returns false for dynamic finders with other postfix values" do
        Entry.respond_to?(:find_by_term_in_de).should == false
      end

      it "returns false for dynamic finders on non-translated fields" do
        Entry.respond_to?(:find_by_note_in_en).should == false
        Entry.respond_to?(:find_by_note_in_source_language).should == false
        Entry.respond_to?(:find_by_note_in_glossary_language).should == false
      end

    end

    describe "#method_missing" do

      before do
        @entry1 = Entry.new(:user => Factory(:user)) 
        @entry1.term_in_en = "term1"
        @entry1.source_language = 'en'

        @entry2 = Entry.new(:user => Factory(:user)) 
        @entry2.term_in_en = "term2"
        @entry2.term_in_ja = "バナナ"
        @entry2.source_language = "ja"

        @entry3 = Entry.new(:user => Factory(:user)) 
        @entry3.term_in_ja = "りんご"
        @entry2.source_language = "ja"
      end

      pending "returns entries with matching terms in English" do
        Entry.find_by_term_in_en("term1").should be(@entry1)
      end

      pending "returns entries with matching terms in Japanese" do
        Entry.find_by_term_in_ja("りんご").should be(@entry3)
      end

      pending "returns entries with matching terms in source language" do
        Entry.find_by_term_in_source_language("term1").should be(@entry1)
        Entry.find_by_term_in_source_language("バナナ").should be(@entry2)
        Entry.find_by_term_in_source_language("りんご").should be(@entry3)
      end
      
      pending "returns entry with matching terms in glossary language" do
        Entry.find_by_term_in_glossary_language("term1").should be(nil)
        Entry.find_by_term_in_glossary_language("バナナ").should be(@entry2)
        Entry.find_by_term_in_glossary_language("りんご").should be(@entry3)
      end

    end

  end

end
