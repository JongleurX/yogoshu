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

    # for a future implementation of multiple glossaries
    it "should be invalid without a glossary"

    it "should be invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

    it "should be invalid if not unique in glossary language" do
      Factory(:entry_ja, :term_in_ja => "りんご")
      subject.term_in_ja = "りんご"
      should_not be_valid
    end
    
  end

  describe "#destroy" do

    before(:each) do
      @entry = Entry.new(:user => Factory(:user)) 
      @entry.term_in_ja = "りんご"
      @entry.term_in_en = "apple"
    end

    it "should destroy the entry" do
      entry_id = @entry.id
      @entry.destroy
      Entry.find_by_id(entry_id).should be_nil
    end

    # to catch bug #17: https://github.com/shioyama/yogoshu/issues/17 this fails in integration test but doesn't here
    it "should destroy all translations of the entry" do
      entry_id = @entry.id
      @entry.destroy
      Entry::Translation.find_by_entry_id(entry_id).should be_nil
    end

  end

  describe "permissions" do

    before(:each) do
      @entry = Entry.new(:user => Factory(:user)) 
      @entry.term_in_ja = "term"
    end

    subject { @entry }

    it { should have_permissions }

  end

end
