# -*- coding: utf-8 -*-
require 'spec_helper'

describe Yogoshu::Locales do

  after do
    I18n.locale = nil
    Globalize.locale = nil
    Yogoshu::Locales.set_glossary_language(:ja)
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

  describe "#set_glossary_language" do

    it "raises an error for an argument that is not a Symbol" do
      expect { Yogoshu::Locales.set_glossary_language("abc") }.to raise_error(ArgumentError)
    end

  end

end

describe Yogoshu::ActsAsGlossary do

  describe "#respond_to?" do

    context "as an instance method" do

      before { Yogoshu::Locales.set_base_languages(:ja, :en) }

      it "returns true for translated attribute with postfix in base_languages" do
        @entry = Entry.new
        @entry.respond_to?(:term_in_en).should == true
        @entry.respond_to?(:term_in_ja).should == true
        @entry.respond_to?(:term_in_glossary_language).should == true
      end

      it "returns false for translated attribute with postfix not in base_languages" do
        @entry = Entry.new
        @entry.respond_to?(:term_in_de).should == false
      end

      it "returns false for non-translated attribute with postfix in base_languages" do
        @entry = Entry.new
        @entry.respond_to?(:note_in_en).should == false
        @entry.respond_to?(:note_in_ja).should == false
        @entry.respond_to?(:note_in_glossary_language).should == false
      end

    end

    context "as a class method" do

      it "returns true for dynamic finders with postfix in base_languages or glossary_language" do
        Entry.respond_to?(:find_by_term_in_en).should == true
        Entry.respond_to?(:find_by_term_in_ja).should == true
        Entry.respond_to?(:find_by_term_in_glossary_language).should == true
        #Entry.respond_to?(:find_all_by_term_in_en).should == true
        #Entry.respond_to?(:find_all_by_term_in_ja).should == true
        #Entry.respond_to?(:find_all_by_term_in_glossary_language).should == true
        #Entry.respond_to?(:find_last_by_term_in_en).should == true
        #Entry.respond_to?(:find_last_by_term_in_ja).should == true
        #Entry.respond_to?(:find_last_by_term_in_glossary_language).should == true
      end

      it "returns false for dynamic finders with other postfix values" do
        Entry.respond_to?(:find_by_term_in_de).should == false
      end

      it "returns false for dynamic finders on non-translated fields" do
        Entry.respond_to?(:find_by_note_in_en).should == false
        Entry.respond_to?(:find_by_note_in_glossary_language).should == false
      end

    end

  end

  describe "#method_missing" do

    context "as an instance method" do

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
        expect { @entry.note_in_glossary_language }.to raise_error(NoMethodError)
      end

    end

    context "as a class method do" do

      before do
        @entry1 = Entry.new(:user => Factory(:user)) 
        @entry1.term_in_ja = "あああ"
        @entry1.term_in_en = "term1"
        @entry1.save

        @entry2 = Entry.new(:user => Factory(:user)) 
        @entry2.term_in_ja = "バナナ"
        @entry2.term_in_en = "term2"
        @entry2.save

        @entry3 = Entry.new(:user => Factory(:user)) 
        @entry3.term_in_ja = "りんご"
        @entry3.save
      end
      
      it "returns entries with matching terms in English" do
        Entry.find_by_term_in_en("term1").should == @entry1
      end

      it "returns entries with matching terms in Japanese" do
        Entry.find_by_term_in_ja("りんご").should == @entry3
      end

      it "returns entry with matching terms in glossary language" do
        Entry.find_by_term_in_glossary_language("term1").should be(nil)
        Entry.find_by_term_in_glossary_language("バナナ").should == @entry2
        Entry.find_by_term_in_glossary_language("りんご").should == @entry3
      end

      pending "returns multiple entries with matching terms in English with _all finder" do
        Entry.find_all_by_term_in_en("term").should == [@entry1, @entry2]
      end

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

        describe "getter functions for glossary_language 'ja'" do
          before { Yogoshu::Locales.set_glossary_language(:ja) }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理化学研究所' }
          its(:term_in_glossary_language) { should == '理化学研究所' }
        end

        describe "getter functions for glossary_language 'en'" do
          before { Yogoshu::Locales.set_glossary_language(:en) }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理化学研究所' }
          its(:term_in_glossary_language) { should == 'RIKEN' }
        end

        describe "setter functions on Japanese term for glossary_language 'ja'" do
          before { Yogoshu::Locales.set_glossary_language(:ja) ; subject.term_in_ja = '理研' }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理研' }
          its(:term_in_glossary_language) { should == '理研' }
        end

        describe "setter functions on English term for glossary_language 'ja'" do
          before { Yogoshu::Locales.set_glossary_language(:ja) ; subject.term_in_en = 'Rikagaku Kenkyujo' }
          its(:term_in_en) { should == 'Rikagaku Kenkyujo' }
          its(:term_in_ja) { should == '理化学研究所' }
          its(:term_in_glossary_language) { should == '理化学研究所' }
        end

        describe "setter functions on glossary_language 'ja'" do
          before { Yogoshu::Locales.set_glossary_language(:ja) ; subject.term_in_glossary_language = '理研' }
          its(:term_in_en) { should == 'RIKEN' }
          its(:term_in_ja) { should == '理研' }
          its(:term_in_glossary_language) { should == '理研' }
        end

      end

    end

  end

end
