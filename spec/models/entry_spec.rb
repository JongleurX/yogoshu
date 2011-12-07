# -*- coding: utf-8 -*-
require 'spec_helper'

describe Entry do

  before do
    I18n.locale = 'en'
    Globalize.locale = 'en'
    Yogoshu::Locale.set_base_languages(:ja, :en)
  end

  describe "validation with factory" do
    
    # factory is not validating so for now using this workaround
    before(:each) do
      Yogoshu::Locale.set_default_source_language(:en)
      @entry = Entry.new(:user => Factory(:user)) 
      @entry.term_in_en = "term"
    end

    after(:each) do
      @entry.destroy
    end

    pending "should be valid created by factory" do
      @entry_factory = Factory(:entry_en)
      @entry_factory.should be_valid
    end

    subject { @entry }

    it "should be valid" do
      should be_valid
    end

    it "should not be valid without a source language term" do
      subject.term = nil
      should_not be_valid
    end

    it "should be invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

    it "should be invalid if not unique in source language" do
      Factory(:entry_en, :term_in_en => "apple")
      subject.term_in_en = "apple"
      should_not be_valid
    end
    
  end

  describe "dynamic finders for translated attributes" do

    describe "#responds_to?" do

      it "returns true for dynamic finders with postfix in base_languages or source_language" do
        Entry.respond_to?(:find_by_term_in_en).should == true
        Entry.respond_to?(:find_by_term_in_ja).should == true
        Entry.respond_to?(:find_by_term_in_source_language).should == true
      end

      it "returns false for dynamic finders with other postfix values" do
        Entry.respond_to?(:find_by_term_in_de).should == false
      end

      it "returns false for dynamic finders on non-translated fields" do
        Entry.respond_to?(:find_by_note_in_en).should == false
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
      
    end

  end

end
