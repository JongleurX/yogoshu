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

  before do
    Yogoshu::Locales.set_base_languages(:ja, :en)
    Yogoshu::Locales.set_glossary_language(:ja)
  end

  context "with anonymous user" do

    before do
      controller.stub(:logged_in?) { false }
    end

    it "should redirect new, create and destroy requests to login page" do
      requests = 
        [
          proc {  get :new },
          proc {  post :create, :entry => {'these' => 'params'} },
          proc {  delete :destroy, :id => "37" },
      ]

      requests.each do |r|
        r.call
        response.should redirect_to(:controller => 'sessions', :action => 'new' )
      end
    end

    describe "GET show" do

      before do
        entry = mock_entry
        Entry.should_receive(:find_by_term_in_glossary_language).with("apple").and_return { entry }
      end

      it "assigns the requested entry as @entry" do
        get :show, :id => "apple"
        assigns(:entry).should be(@mock_entry)
      end

    end

  end

  context "with logged-in user" do

    before do
      controller.stub(:logged_in?) { true }
      user = mock_user
      controller.stub(:current_user) { user }
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

    describe "POST create" do

      context "with valid params" do
        before do
          entry = mock_entry
          entry.should_receive(:save).and_return { true }
          Entry.stub(:new).with( { 'these' => 'params', 'user_id' => @mock_user.id } ) { entry }
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
          Entry.stub(:new).with( 'these' => 'params', 'user_id' => @mock_user.id ) { entry }
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

    describe "PUT update" do

      before do
        request.env['HTTP_REFERER'] = "http://www.ablog.com/"
      end

      def updates_entry(entry)
        Entry.should_receive(:find_by_term_in_glossary_language).and_return(entry)
        entry.should_receive(:update_attributes!)
        put :update, :id => "りんご"
      end

      def redirects_back(entry)
        Entry.stub(:find_by_term_in_glossary_language) { entry }
        put :update, :id => "りんご"
        response.should redirect_to(:back)
      end

      def responds_with_unauthorized(entry)
        Entry.stub(:find_by_term_in_glossary_language) { entry }
        put :update, :id => "りんご"
        response.status.should == 401
      end

      context "with contributor role" do

        before do
          user = mock_user(:manager? => false)
          controller.stub(:current_user) { user }
        end

        context "for own entry" do

          before do
            @entry = Entry.create!(:user => mock_user, :term_in_ja => "りんご")
          end

          it "updates the requested entry" do
            updates_entry(@entry)
          end

          it "redirects to the previous page" do
            redirects_back(@entry)
          end

          it "returns a success message"

        end

        context "for other user's entry" do

          before do
            other_user = mock_model(User)
            @entry = Entry.create!(:user => other_user, :term_in_ja => "りんご")
          end
        
          it "responds with unauthorized" do
            responds_with_unauthorized(@entry)
          end

          it "returns an error message"
          
        end

      end

      context "with manager role" do

        before do
          user = mock_user(:manager? => true)
          controller.stub(:current_user) { user }

          other_user = mock_model(User)
          @entry = Entry.create!(:user => other_user, :term_in_ja => "りんご")
        end

        it "updates the requested entry" do
          updates_entry(@entry)
        end

        it "redirects to the previous page" do
          redirects_back(@entry)
        end

        it "returns a success message"

      end

    end

    describe "DELETE destroy" do

      def destroys_entry(entry)
        Entry.should_receive(:find_by_term_in_glossary_language).and_return(entry)
        entry.should_receive(:destroy)
        delete :destroy, :id => "りんご"
      end

      def redirects_to_entries(entry)
        Entry.stub(:find_by_term_in_glossary_language) { entry }
        delete :destroy, :id => "りんご"
        response.should redirect_to(entries_path)
      end

      def responds_with_unauthorized(entry)
        Entry.stub(:find_by_term_in_glossary_language) { entry }
        delete :destroy, :id => "りんご"
        response.status.should == 401
      end

      context "with contributor role" do

        before do
          user = mock_user(:manager? => false)
          controller.stub(:current_user) { user }
        end

        context "for own entry" do

          before do
            @entry = Entry.create!(:user => mock_user, :term_in_ja => "りんご")
          end

          it "destroys the requested entry" do
            destroys_entry(@entry)
          end

          it "redirects to the entries_index" do
            redirects_to_entries(@entry)
          end

          it "returns a success message"

        end

        context "for other user's entry" do

          before do
            other_user = mock_model(User)
            @entry = Entry.create!(:user => other_user, :term_in_ja => "りんご")
          end
        
          it "responds with unauthorized" do
            responds_with_unauthorized(@entry)
          end

          it "returns an error message"

        end

      end

      context "with manager role" do

        before do
          user = mock_user(:manager? => true)
          controller.stub(:current_user) { user }

          other_user = mock_model(User)
          @entry = Entry.create!(:user => other_user, :term_in_ja => "りんご")
        end

        it "destroys the requested entry" do
          destroys_entry(@entry)
        end

        it "redirects to the entries_index" do
          redirects_to_entries(@entry)
        end

        it "returns a success message"

      end

    end

  end

end
