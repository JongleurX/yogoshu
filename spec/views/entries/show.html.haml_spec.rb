# -*- coding: utf-8 -*-
require 'spec_helper'

describe "entries/show" do
  
  before do
    Yogoshu::Locales.set_glossary_language(:ja)
  end

  # to avoid this annoying regex warning: /home/chris/.rbenv/versions/1.9.2-p290/lib/ruby/gems/1.9.1/bundler/gems/rails-f407ec5f792c/activesupport/lib/active_support/core_ext/string/output_safety.rb:23: warning: regexp match /.../n against to UTF-8 string 
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
        Timecop.freeze(Time.utc(2012,7,1,10,5,0)) do
          @entry = FactoryGirl.create(:entry_en, :term_in_en => "apple", :term_in_ja => "りんご", :info => "A yummy fruit.", :note => "Here's a simple word in Japanese and English. I found it on this site: http://abc.com . some text\nHere's some more text.")
        end
      end

      context "logged-out user" do

        before do
          view.stub(:logged_in?) { false }
        end

        it "has glossary terms in all languages" do
          render
          rendered.should =~ /apple/
          rendered.should =~ /りんご/
        end

        it "has user info" do
          render
          rendered.should have_link(@entry.user.name)

        end

        it "has created_at and updated_on info" do
          Timecop.freeze(Time.utc(2012,7,5,16,10,0)) do
            @entry.update_attributes!(:info => "A yummy yummy fruit.")
            render
            rendered.should =~ /on July 1, 2012 @ 10:05 AM/
            rendered.should =~ /Last updated on July 5, 2012 @ 4:10 PM/
            @entry.update_attributes!(:info => "A yummy fruit.")
          end
        end

        it "has usage info" do
          render
          rendered.should =~ /A yummy fruit./
        end

        it "does not have translator notes" do
          render
          rendered.should_not =~ /Here's a simple word in Japanese and English./
        end

      end

      context "logged-in user" do

        before do
          view.stub(:logged_in?) { true }
          User.current_user = @current_user = FactoryGirl.create(:user)
          view.stub(:manager?) { false }
        end

        it "has glossary terms in all languages" do
          render
          rendered.should =~ /apple/
          rendered.should =~ /りんご/
        end

        it "has usage info" do
          render
          rendered.should =~ /A yummy fruit./
        end

        it "has translator note" do
          render
          rendered.should =~ /Here's a simple word in Japanese and English./
        end

        it "autolinks any links in translator note" do
          render
          rendered.should have_link("http://abc.com", :href => "http://abc.com")
        end

        it "translates linebreaks in translator note into <br> tags" do
          render
          rendered.gsub("\n","").should =~ /some text<br \/>Here/
          rendered.gsub("\n","").should =~ /<p>Here\'s a simple/
        end

        it "has delete and edit but not approve actions if entry is created by this user" do
          @entry.stub(:changeable_by?).with(@current_user) { true }
          render
          rendered.should have_link "Delete", :href => entry_path(@entry)
          rendered.should have_link "Edit", :href => edit_entry_path(@entry)
          rendered.should_not have_link "Approve"
        end

        it "has neither delete nor approve actions if entry not created by his user" do
          @entry.stub(:changeable_by?).with(@current_user) { false }
          render
          rendered.should_not have_link "Delete"
          rendered.should_not have_link "Edit"
          rendered.should_not have_link "Approve"
        end

      end

      context "logged-in manager" do

        before do
          view.stub(:logged_in?) { true }
          User.current_user = @current_user = FactoryGirl.create(:user)
          view.stub(:manager?) { true }
          @entry.stub(:changeable_by?).with(@current_user) { true }
        end

        it "has both delete and approve actions" do
          render
          rendered.should have_link "Delete", :href => entry_path(@entry)
          rendered.should have_link "Edit", :href => edit_entry_path(@entry)
          rendered.should have_link "Approve", :href => approve_entry_path(@entry, :entry => { :approved => true})
        end

      end

    end

  end

end
