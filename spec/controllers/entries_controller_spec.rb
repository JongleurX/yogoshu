# -*- coding: utf-8 -*-
require 'spec_helper'

describe EntriesController do

  def mock_entry(stubs={})
    (@mock_entry ||= mock_model(Entry).as_null_object).tap do |entry|
      entry.stub(stubs) unless stubs.empty?
    end
  end

  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  # for approving entries
  def updates_entry(entry)
    Entry.should_receive(:find_by_term_in_glossary_language).and_return(entry)
    entry.should_receive(:update_attributes)
    put :update, :id => "りんご", :entry => { 'these' => 'params' }
  end

  def responds_with_updated(entry)
    Entry.stub(:find_by_term_in_glossary_language) { entry }
    entry.stub(:update_attributes) { true }
    put :update, :id => "りんご", :entry => { 'these' => 'params' }
    response.should render_template(entry)
  end

  def update_responds_with_error(entry)
    put :update, :id => "りんご", :entry => { 'these' => 'params' }
    response.should redirect_to(@entry)
    flash[:error].should == "You are not authorized to edit this entry." 
  end

  # for updating entries
  def approves_entry(entry)
    Entry.should_receive(:find_by_term_in_glossary_language).and_return(entry)
    entry.should_receive(:update_attributes).and_return(true)
    post :approve, :id => "りんご", :entry => { :approved => true }
  end

  def responds_with_approved(entry)
    Entry.stub(:find_by_term_in_glossary_language) { entry }
    entry.stub(:update_attributes) { true }
    post :approve, :id => "りんご", :entry => { :approved => true }
    response.should render_template(entry)
  end

  # for destroy
  def destroys_entry(entry)
    Entry.should_receive(:find_by_term_in_glossary_language).and_return(entry)
    entry.should_receive(:destroy)
    delete :destroy, :id => "りんご"
  end

  def destroy_redirects_to_entries(entry, url)
    Entry.stub(:find_by_term_in_glossary_language) { entry }
    delete :destroy, :id => "りんご"
    response.should redirect_to(url)
  end

  def destroy_responds_with_error(entry)
    Entry.stub(:find_by_term_in_glossary_language) { entry }
    delete :destroy, :id => "りんご"
    response.should redirect_to(@entry)
    flash[:error].should == "You are not authorized to edit this entry."
  end

  before do
    Yogoshu::Locales.set_base_languages(:ja, :en)
    Yogoshu::Locales.set_glossary_language(:ja)
    request.env['HTTP_REFERER'] = "http://www.ablog.com/"
  end

  context "with anonymous user" do

    before do
      controller.stub(:logged_in?) { false }
    end

    it "redirects new, edit, create, update and destroy requests to login page" do
      requests = 
        [
          proc {  get :new },
          proc {  get :edit },
          proc {  post :create, :entry => {'these' => 'params'} },
          proc {  put :update, :id => "37" },
          proc {  delete :destroy, :id => "37" },
      ]

      requests.each do |r|
        r.call
        response.should redirect_to(:controller => 'sessions', :action => 'new' )
      end
    end

    describe "GET index" do

      it "assigns search results as @entries"

    end

    describe "GET show" do

      context "entry exists" do

        before do
          entry = mock_entry
          Entry.should_receive(:find_by_term_in_glossary_language).with("apple").and_return { entry }
        end

        it "assigns the requested entry as @entry" do
          get :show, :id => "apple"
          assigns(:entry).should be(@mock_entry)
        end

      end

      context "entry does not exist" do

        before do
          Entry.should_receive(:find_by_term_in_glossary_language).with("apple").and_return { nil }
        end

        it "raises routing error" do
          lambda {
            get :show, :id => "apple"
          }.should raise_error(ActionController::RoutingError)
        end

      end

    end

    describe "GET autocomplete_entry_term" do

      pending "returns only approved entries" do
        get :autocomplete_entry_term, :term => "apple", :format => :json
      end
    end

  end

  context "with logged-in user" do

    before do
      controller.stub(:logged_in?) { true }
      user = mock_user
      controller.stub(:current_user) { user }
    end

    describe "entry does not exist" do

      before do
        Entry.stub(:find_by_term_in_glossary_language).with("apple") { nil }
      end

      it "raises routing error for get, put, post and delete requests" do

        requests =
          [
            proc {  get :edit, :id => "apple" },
            proc {  put :update, :id => "apple" },
            proc {  post :approve, :id => "apple" },
            proc {  delete :destroy, :id => "apple" },
        ]

        requests.each do |r|
          lambda {
            r.call
          }.should raise_error(ActionController::RoutingError)
        end

      end

    end

    describe "GET new" do

      before do
        entry = mock_entry
        Entry.should_receive(:new).and_return { entry }
      end

      it "assigns newly created entry as @entry" do
        get :new
        assigns(:entry).should be(@mock_entry)
      end

      it "renders the new view" do
        get :new
        response.should render_template('new')
      end

    end

    describe "GET edit" do

      before do
        entry = mock_entry
      end

      context "with contributor role" do

        before do
          user = mock_user(:manager? => false)
          controller.stub(:current_user) { user }
        end

        context "for own entry" do
          it "renders the edit page for the entry"
        end

        context "for other user's entry" do
          it "redirects to the show page and returns error message"
        end

      end

      context "with manager role" do
        it "renders the edit page for the entry"
      end

    end

    describe "GET autocomplete_entry_term" do

      it "returns approved and unapproved entries"

    end

    describe "POST create" do

      context "with valid params" do
        before do
          entry = mock_entry
          entry.should_receive(:save).and_return { true }
          Entry.stub(:new).with( { 'these' => 'params' } ) { entry }
        end

        it "assigns newly created entry as @entry" do
          post :create, :entry => {'these' => 'params'}
          assigns(:entry).should be(@mock_entry)
        end

        it "redirects to the entry" do
          post :create, :entry => {'these' => 'params'}
          response.should redirect_to entry_path(@mock_entry)
        end

        it "displays a success message" do
          post :create, :entry => {'these' => 'params'}
          flash[:success].should == "New glossary entry has been created." 
        end

      end

      context "with invalid params" do
        before do
          entry = mock_entry
          entry.should_receive(:save).and_return { false }
          Entry.stub(:new).with( 'these' => 'params' ) { entry }
        end

        it "assigns newly created entry as @entry" do
          post :create, :entry => {'these' => 'params'}
          assigns(:entry).should be(@mock_entry)
        end

        it "re-renders the new entry page" do
          post :create, :entry => {'these' => 'params'}
          response.should render_template('new')
        end

        it "displays an error message" do
          post :create, :entry => {'these' => 'params'}
          flash[:error].should == 'There were errors in the information entered.'
        end

      end

    end

    describe "POST approve" do 
      
      context "with contributor role" do

        before do
          user = mock_user(:manager? => false)
          controller.stub(:current_user) { user }
          @entry = FactoryGirl.create(:entry, :user => user, :term_in_ja => "りんご")
        end

        it "redirects to entry and returns error message" do
          Entry.stub(:find_by_term_in_glossary_language) { @entry }
          post :approve, :id => "りんご", :entry => { :approved => true }
          response.should redirect_to(@entry)
          flash[:error].should == "Only managers can approve entries."
        end

      end

      context "with manager role" do

        before do
          user = mock_user(:manager? => true)
          controller.stub(:current_user) { user }

          @entry = FactoryGirl.create(:entry, :user => user, :term_in_ja => "りんご")
          Entry.stub(:find_by_term_in_glossary_language) { @entry }
        end

        it "approves the entry" do
          approves_entry(@entry)
        end

        it "responds with approved entry" do
          responds_with_approved(@entry)
        end

        it "returns a success message"

      end

    end

    describe "PUT update" do

      context "with contributor role" do

        before do
          user = mock_user(:manager? => false)
          controller.stub(:current_user) { user }
        end

        context "for own entry" do

          before do
            @entry = FactoryGirl.create(:entry, :user => mock_user, :term_in_ja => "りんご")
          end

          it "updates the requested entry" do
            updates_entry(@entry)
          end

          it "responds with updated entry" do
            responds_with_updated(@entry)
          end

          it "returns a success message"

        end

        context "for other user's entry" do

          before do
            other_user = mock_model(User)
            @entry = FactoryGirl.create(:entry, :user => other_user, :term_in_ja => "りんご")
          end

          it "redirects to entry and returns error message" do
            update_responds_with_error(@entry)
          end

        end

      end

      context "with manager role" do

        before do
          user = mock_user(:manager? => true)
          controller.stub(:current_user) { user }

          other_user = mock_model(User)
          @entry = FactoryGirl.create(:entry, :user => other_user, :term_in_ja => "りんご")
        end

        it "updates the requested entry" do
          updates_entry(@entry)
        end

        it "responds with the updated entry" do
          responds_with_updated(@entry)
        end

        it "returns a success message"

      end

    end

    describe "DELETE destroy" do

      context "with contributor role" do

        before do
          user = mock_user(:manager? => false)
          controller.stub(:current_user) { user }
        end

        context "for own entry" do

          before do
            @entry = FactoryGirl.create(:entry, :user => mock_user, :term_in_ja => "りんご")
          end

          it "destroys the requested entry" do
            destroys_entry(@entry)
          end

          it "redirects to entries index with original query string" do
            request.env["HTTP_REFERER"] = "http://ablog.com?page=3"
            destroy_redirects_to_entries(@entry,'/entries?page=3')
          end

          it "returns a success message"

        end

        context "for other user's entry" do

          before do
            other_user = mock_model(User)
            @entry = FactoryGirl.create(:entry, :user => other_user, :term_in_ja => "りんご")
          end

          it "redirects to entry and returns error message" do
            destroy_responds_with_error(@entry)
          end

        end

      end

      context "with manager role" do

        before do
          user = mock_user(:manager? => true)
          controller.stub(:current_user) { user }

          other_user = mock_model(User)
          @entry = FactoryGirl.create(:entry, :user => other_user, :term_in_ja => "りんご")
        end

        it "destroys the requested entry" do
          destroys_entry(@entry)
        end

        it "redirects to the entries_index" do
          request.env["HTTP_REFERER"] = "http://ablog.com?page=3"
          destroy_redirects_to_entries(@entry,'/entries?page=3')
        end

        it "returns a success message"

      end

    end

  end

end
