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

  end

  context "with logged-in user" do

    before do
      controller.stub(:logged_in?) { true }
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
          Entry.stub(:new).with( 'these' => 'params' ) { entry }
        end

        it "assigns newly created entry as @entry"

        it "redirects to the homepage"

        it "displays a success message"

      end

    end
    
  end

end
