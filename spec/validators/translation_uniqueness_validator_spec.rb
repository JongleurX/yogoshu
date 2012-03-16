# -*- coding: utf-8 -*-
require 'spec_helper'
require 'yogoshu/acts_as_glossary'

describe TranslationUniquenessValidator do

  context "English locale" do

    before { I18n.locale = Globalize.locale = :en }

    describe "without postfix" do
      before do
        Validatee.class_eval { validates :string, :translation_uniqueness => true }
        Validatee.create!(:string => "a")
      end

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
    end

    context "with postfix" do
      before do
        Validatee.class_eval { validates :string_in_en, :translation_uniqueness => true }
        Validatee.create!(:string_in_en => "a")
      end

      describe "create" do

        it "validates uniqueness in target language" do
          Validatee.new(:string_in_en => "a").should_not be_valid
          Validatee.new(:string_in_en => "b").should be_valid
        end

        it "does not validate uniqueness in other language" do
          Validatee.new(:string_in_ja => "a").should be_valid
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
