# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yogoshu/acts_as_glossary'

describe TranslationUniquenessValidator do

  context "English locale" do

    before { I18n.locale = Globalize.locale = :en }

    describe "without postfix" do
      before(:all) do
        class Validatee < ActiveRecord::Base
          translates :string
          validates :string, :translation_uniqueness => { :message => "is already in the glossary" } 
        end
      end
      after(:all) { Object.send(:remove_const, :Validatee) }

      before { Validatee.create!(:string => "a") }

      it "validates uniqueness on create" do
        Validatee.new(:string => "a").should_not be_valid
        Validatee.new(:string => "b").should be_valid
      end

      it "validates uniqueness on update" do
        validatee = Validatee.create(:string => "b")
        validatee.update_attributes(:string => "a")
        validatee.should_not be_valid
        validatee.update_attributes(:string => "b")
        validatee.should be_valid
        validatee.update_attributes(:string => "c")
        validatee.should be_valid
      end

      it "assigns error message" do
        validatee = Validatee.new(:string => "a")
        validatee.valid?
        validatee.errors[:string].should == ["is already in the glossary"]
      end
    end

    context "with postfix" do
      before(:all) do
        class Validatee < ActiveRecord::Base
          translates :string
          validates :string_in_en, :translation_uniqueness => { :message => "is already in the glossary" } 
        end
      end
      after(:all) { Object.send(:remove_const, :Validatee) }

      before { Validatee.create!(:string_in_en => "a") }

      describe "create" do

        it "validates uniqueness in target language" do
          Validatee.new(:string_in_en => "a").should_not be_valid
          Validatee.new(:string_in_en => "b").should be_valid
        end

        it "does not validate uniqueness in other language" do
          Validatee.new(:string_in_ja => "a").should be_valid
        end

        it "assigns error message" do
          validatee = Validatee.new(:string_in_en => "a")
          validatee.valid?
          validatee.errors[:string_in_en].should == ["is already in the glossary"]
        end
      end

      describe "update" do

        it "validates uniqueness in target language" do
          validatee = Validatee.create(:string_in_en => "b")
          validatee.update_attributes(:string_in_en => "a")
          validatee.should_not be_valid
          validatee.update_attributes(:string_in_en => "b")
          validatee.should be_valid
          validatee.update_attributes(:string_in_en => "c")
          validatee.should be_valid
        end

        it "does not validate uniqueness in other language" do
          validatee = Validatee.create(:string_in_ja => "b")
          validatee.update_attributes(:string_in_ja => "a")
          validatee.should be_valid
        end

      end
    end
  end
end
