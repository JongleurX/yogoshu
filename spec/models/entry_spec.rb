require 'spec_helper'

describe Entry do

  before do
    I18n.locale = 'en'
    Globalize.locale = 'en'
  end

  describe "validation with factory" do
    
    before do
      @entry = Factory(:glossary_entry_en)
    end

    subject { @entry }

    it "should be valid created by factory" do
      should be_valid
    end

    it "should not be valid without a source language term" do
      subject.term = nil
      should_not be_valid
    end

    it "should be valid without terms in other languages"

    it "should be invalid without a source language" do
      subject.source_language = nil
      should_not be_valid
    end

    it "should be invalid without a user" do
      subject.user = nil
      should_not be_valid
    end
    
  end

end
