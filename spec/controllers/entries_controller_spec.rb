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

    describe "DELETE destroy" do

      it "destroys the requested entry" do
        Entry.should_receive(:find_by_term_in_glossary_language).with("apple") { mock_entry }
        mock_entry.should_receive(:destroy)
        delete :destroy, :id => "apple", :locale => 'en'
      end

      it "redirects to the homepage" do
        Entry.stub(:find_by_term_in_glossary_language) { mock_entry }
        delete :destroy, :id => "apple", :locale => 'en'
        response.should redirect_to(entries_path)
      end

    end
    
  end

end
