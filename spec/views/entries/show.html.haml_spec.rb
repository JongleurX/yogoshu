# -*- coding: utf-8 -*-
require 'spec_helper'

describe "entries/show.html.haml" do
  
  before do
    view.stub(:logged_in?) { true }
    Yogoshu::Locales.set_glossary_language(:ja)
  end

  # to avoid this annoying regex warningt: /home/chris/.rbenv/versions/1.9.2-p290/lib/ruby/gems/1.9.1/bundler/gems/rails-f407ec5f792c/activesupport/lib/active_support/core_ext/string/output_safety.rb:23: warning: regexp match /.../n against to UTF-8 string 
  around(:each) do |example|
    silence_warnings do
      example.run
    end
  end

  context "English locale" do

    before do
      I18n.locale = 'en'
    end

    describe "show entry in bilingual glossary" do

      before do
        Yogoshu::Locales.set_base_languages(:ja, :en)
        assign(:base_languages, %w[en ja])
        @entry = Factory(:entry_en, :term_in_en => "apple", :term_in_ja => "りんご", :note => "Here's a simple word in Japanese and English. I found it on this site: http://abc.com . some text\nHere's some more text.")
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

        it "should translate linebreaks in note into <br> tags" do
          render
          rendered.gsub("\n","").should =~ /some text<br \/>Here/
          rendered.gsub("\n","").should =~ /<p>Here\'s a simple/
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
