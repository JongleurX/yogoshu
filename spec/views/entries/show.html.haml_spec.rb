# -*- coding: utf-8 -*-
require 'spec_helper'

describe "entries/show.html.haml" do
  
  before do
    view.stub(:logged_in?) { true }
  end

  context "English locale" do

    before do
      I18n.locale = 'en'
    end

    describe "show entry in bilingual glossary" do

      before do
        Yogoshu::Locale.set_base_languages(:en, :ja)
        assign(:base_languages, %w[en ja])
        @entry = Factory(:entry_en, :term_in_en => "apple", :term_in_ja => "りんご", :note => "Here's a simple word in Japanese and English. I found it on this site: http://abc.com .")
      end

      context "logged-in user" do

        before do
          view.stub(:manager?) { false }
        end

        it "should have English glossary term" do
          render
          rendered.should =~ /apple/
        end

        it "should have Japanese glossary term" do
          render
          rendered.should =~ /りんご/
        end

        it "should have note" do
          render
          rendered.should =~ /Here's a simple word in Japanese and English./
        end

        it "should autolink any links in note" do
          render
          rendered.should have_link("http://abc.com", :href => "http://abc.com")
        end

        it "should not have manager actions" do
          render
          rendered.should_not have_link "Delete"
          rendered.should_not have_link "Approve"
        end

      end

      context "logged-in manager" do

        before do
          view.stub(:manager?) { true }
        end

        it "should have manager actions" do
          render
          rendered.should have_link "Delete", :href => entry_path(@entry)
          rendered.should have_link "Approve", :href => entry_path(@entry, :entry => { :approved => true})
        end

      end

    end

  end

end
