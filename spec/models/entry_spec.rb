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
    
    before do
      @entry = FactoryGirl.create(:entry)
    end
    
    subject { @entry }

    it "should be valid created by factory" do
      should be_valid
    end

    # for a future implementation of multiple glossaries
    it "should be invalid without a glossary"

    it "should be invalid without a user" do
      subject.user = nil
      should_not be_valid
    end

    it "should be invalid if not unique in glossary language" do
      FactoryGirl.create(:entry, :term_in_ja => "りんご")
      subject.term_in_ja = "りんご"
      should_not be_valid
    end
    
  end

  describe "#destroy" do

    before(:each) do
      @entry = FactoryGirl.create(:entry, :term_in_ja => "りんご", :term_in_en => "apple")
    end

    it "should destroy the entry" do
      entry_id = @entry.id
      @entry.destroy
      Entry.find_by_id(entry_id).should be_nil
    end

    it "should destroy all translations of the entry" do
      entry_id = @entry.id
      @entry.destroy
      Entry::Translation.find_by_entry_id(entry_id).should be_nil
    end

  end

  describe "permissions" do

    before(:each) do
      @entry = FactoryGirl.create(:entry) 
    end

    subject { @entry }

    it { should have_permissions }

  end

end
