require 'spec_helper'

describe Entry do

  before do
    I18n.locale = 'en'
    Globalize.locale = 'en'
  end

  describe "validation with factory" do
    
    # factory is not validating so for now using this workaround
    before(:each) do
      @entry = Entry.new(:source_language => 'en', :user => Factory(:user)) 
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

end
