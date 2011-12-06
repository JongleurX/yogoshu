# -*- coding: utf-8 -*-
require 'spec_helper'

describe Yogoshu::Locale do

  after do
    I18n.locale = nil
    Globalize.locale = nil
    Yogoshu::Locale::set_base_languages(:en, :ja)
  end

  describe "translated field access with postfix" do

    context "2-languages(:en, :ja)" do

      include Yogoshu::Locale

      before do
        Yogoshu::Locale::set_base_languages(:en, :ja)
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
