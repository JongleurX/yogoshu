# -*- coding: utf-8 -*-
require 'spec_helper'

describe Yogoshu::Locales do

  after do
    I18n.locale = nil
    Globalize.locale = nil
    Yogoshu::Locales.set_base_languages(:ja, :en)
  end

  describe "#set_base_languages" do

    it "raises an error for arguments that are not Symbols" do
      expect { Yogoshu::Locales.set_base_languages(:en, "abc") }.to raise_error(ArgumentError)
    end

    it " assigns base_languages" do
      Yogoshu::Locales.set_base_languages(:de, :ja)
      Yogoshu::Locales.base_languages.should == [:de, :ja]
    end

  end

  describe "#respond_to?" do

    before { Yogoshu::Locales.set_base_languages(:ja, :en) }

    it "returns true for translated attribute with postfix in base_languages" do
      @entry = Entry.new
      @entry.respond_to?(:term_in_en).should == true
      @entry.respond_to?(:term_in_ja).should == true
    end

    it "returns false for translated attribute with postfix not in base_languages" do
      @entry = Entry.new
      @entry.respond_to?(:term_in_de).should == false
    end

    it "returns false for non-translated attribute with postfix in base_languages" do
      @entry = Entry.new
      @entry.respond_to?(:note_in_en).should == false
      @entry.respond_to?(:note_in_ja).should == false
      @entry.respond_to?(:note_in_source_language).should == false
    end

  end

  describe "#method_missing" do

    before { Yogoshu::Locales.set_base_languages(:ja, :en) }

    it "raises a NoMethodError unless postfix is a locale in base_languages" do
      @entry = Entry.new
      expect { @entry.term_in_ja }.not_to raise_error
      expect { @entry.term_in_en }.not_to raise_error
      expect { @entry.term_in_de }.to raise_error(NoMethodError)
    end

    it "raises a NoMethodError for postfix on non-translated attribute" do
      @entry = Entry.new
      expect { @entry.note_in_ja }.to raise_error(NoMethodError)
      expect { @entry.note_in_en }.to raise_error(NoMethodError)
      expect { @entry.note_in_source_language }.to raise_error(NoMethodError)
    end

  end

  describe "translated field access with postfix" do

    context "2-languages(:ja, :en)" do

      before do
        Yogoshu::Locales.set_base_languages(:ja, :en)
      end

      context "given an entry with term 'RIKEN' in :en and '理化学研究所' in :ja" do

        before do
          @entry = Entry.new
          Globalize.with_locale(:en) do
            @entry.term = 'RIKEN'
          end
          Globalize.with_locale(:ja) do
            @entry.term = '理化学研究所'
          end
        end

        subject { @entry }

        describe "getter functions for source_language 'ja'" do
          before { subject.source_language = 'ja' }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理化学研究所' }
          its(:term_in_source_language) { should == '理化学研究所' }
        end

        describe "getter functions for source_language 'en'" do
          before { subject.source_language = 'en' }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理化学研究所' }
          its(:term_in_source_language) { should == 'RIKEN' }
        end
        
        describe "getter functions for source_language 'nil'" do
          before { subject.source_language = nil }
          its(:term_in_source_language) { should == nil }
        end

        describe "setter functions on Japanese term for source_language 'ja'" do
          before { subject.source_language = 'ja' ; subject.term_in_ja = '理研' }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理研' }
          its(:term_in_source_language) { should == '理研' }
        end

        describe "setter functions on English term for source_language 'ja'" do
          before { subject.source_language = 'ja' ; subject.term_in_en = 'Rikagaku Kenkyujo' }
          its(:term_in_en) { should == 'Rikagaku Kenkyujo' }
          its(:term_in_ja) { should == '理化学研究所' }
          its(:term_in_source_language) { should == '理化学研究所' }
        end

        describe "setter functions on source_language 'ja'" do
          before { subject.source_language = 'ja' ; subject.term_in_source_language = '理研' }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理研' }
          its(:term_in_source_language) { should == '理研' }
        end

      end

    end

  end

end
