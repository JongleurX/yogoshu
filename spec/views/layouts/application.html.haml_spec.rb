require 'spec_helper'

describe "layouts/application.html.haml" do
      
  context "logged-out user" do

    before do
      view.stub(:logged_in?) { false }
    end

    describe "logo" do
      it "should have the Yogoshu logo" do
        render
        rendered.should have_selector("a", :href => "/", :text => "Yogoshu")
      end
    end

    describe "login box" do
      it "should render the username and password fields" do
        render
        rendered.should have_selector("form input[@type='text'][@name='user[name]']")
        rendered.should have_selector("form input[@type='password'][@name='user[password]']")
      end
      it "should render the login button" do
        render
        rendered.should have_selector("form button[@type='submit']", :text => "Login")
      end
    end

  end

  context "logged-in user" do

    before do
      view.stub(:logged_in?) { true }
      view.stub(:manager?) { false }
      assign(:current_user, Factory(:alice))
    end

    describe "menu items" do
      it "should have a link to search" do
        render
        rendered.should have_selector("a", :href => '/', :text => "Search")
      end
      it "should have an add entry link" do
        render
        rendered.should have_selector("a", :href => '/entries/new', :text => "Add Entry")
      end
    end

    describe "my profile info" do
      it "should have a drop-down menu with username" do
        render
        rendered.should have_selector("a", :href => "#", :text => "alice")
      end
      it "should have a link to user profile" do
        render
        rendered.should have_selector("a", :href => '/users/alice', :text => "Profile")
      end
      it "should have logout link" do
        render
        rendered.should have_selector("a", :href => '/logout', :text => "Logout")
      end
    end

  end

end
