require 'spec_helper'

describe UsersController do
  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end

  context "with anonymous user" do

    before do
      controller.stub(:current_user) { nil }
    end

    it "should redirect new, edit, create, update & destroy requests to login page" do
      requests = 
        [
          proc { get :new },
          proc { get :edit, :id => "susan" },
          proc {  post :create, :user => {'these' => 'params'} },
          proc {  put :update, :id => "susan" },
          proc {  delete :destroy, :id => "susan" },
      ]

      requests.each do |r|
        r.call
        response.should redirect_to(:controller => 'sessions', :action => 'new' )
      end
    end

    describe "GET show" do
      before do
        user = mock_user
        User.should_receive(:find_by_name!).with("susan").and_return { user }
      end

      it "assigns the requested user as @user" do
        get :show, :id => "susan"
        assigns(:user).should be(@mock_user)
      end

      it "renders the show view" do
        get :show, :id => "susan"
        response.should render_template("show")
      end
    end

    describe "GET index" do
      before do
        user = mock_user
        User.should_receive(:find).with(:all).and_return { [user] }
      end

      it "assigns requested users as @users" do
        get :index
        assigns(:users).should eq([@mock_user])
      end

      it "renders the index view" do
        get :index
        response.should render_template("index")
      end

    end

  end

  context "with logged-in user" do

    before do
      controller.stub(:logged_in?) { true }
      controller.stub(:manager?) { false }
    end

    it "should redirect create & new requests to login page" do
      requests = 
        [
          proc {  post :create, :user => {'these' => 'params'} },
          proc {  get :new },
      ]

      requests.each do |r|
        r.call
        response.should redirect_to(homepage_path)
      end
    end

    describe "GET edit" do

      before do
        user = mock_user(:name => "alice")
        controller.stub(:current_user) { user }
        User.stub(:find_by_name!).with("alice") { user }
      end

      it "assigns the requested user as @user" do
        get :edit, :id => "alice"
        assigns(:user).should be(@mock_user)
      end

      it "renders the edit view" do
        get :edit, :id => "alice"
        response.should render_template('edit')
      end

    end

    describe "PUT update" do

      before do
        user = mock_user(:name => "alice")
        controller.stub(:current_user) { user }
        User.stub(:find_by_name!).with("alice") { user }
      end

      context "with valid params" do
        before do
          @mock_user.should_receive(:update_attributes).and_return { true }
        end

        it "responds with the user" do
          put :update, :id => "alice", :user => { 'these' => 'params' }
          response.should render_template(@mock_user)
        end

        it "returns a success message" do
          put :update, :id => "alice", :user => { 'these' => 'params' }
          flash[:success].should == 'User alice has been updated.'
        end

      end

      context "with invalid params" do
        before do
          @mock_user.should_receive(:update_attributes).and_return { false }
          @mock_user.stub(:name) { "alice" }
        end

        it "resets the name attribute" do
          put :update, :id => "alice", :user => { 'these' => 'params' }
          assigns[:user][:name].should == "alice"

        end
        it "re-renders the edit user page" do
          put :update, :id => "alice", :user => { 'these' => 'params' }
          response.should render_template("edit")
        end

        it "returns error message" do
          put :update, :id => "alice", :user => { 'these' => 'params' }
          flash[:error].should == 'There were errors in the information entered.'
        end

      end

    end

    describe "DELETE destroy" do

      context "with valid params" do

        before do
          user = mock_user(:name => "alice")
          controller.stub(:current_user) { user }
          User.stub(:find_by_name!).with("alice") { user }
          user.should_receive(:destroy).and_return { true }
        end

        it "redirects to the users list" do
          delete :destroy, :id => "alice"
          response.should redirect_to(users_path)
        end

        it "returns a success message" do
          delete :destroy, :id => "alice"
          flash[:success].should == 'User alice has been destroyed.'
        end

      end

      context "with invalid params" do

        before do
          user = mock_user
          User.stub(:find_by_name!).with("alice") { user }
          user.should_receive(:destroy).and_return { false }
        end

        it "redirects to the users list" do
          delete :destroy, :id => "alice"
          response.should redirect_to(users_path)
        end

        it "displays an error message"

      end

    end

  end

  context "with logged-in manager" do

    before do
      controller.stub(:logged_in?) { true }
      controller.stub(:manager?) { true }
    end

    describe "GET new" do

      before do
        user = mock_user
        User.should_receive(:new).and_return { user }
      end

      it "assigns newly created user as @user" do
        get :new
        assigns(:user).should be(@mock_user)
      end

      it "renders the new view" do
        get :new
        response.should render_template('new')
      end

    end

    describe "POST create" do

      context "with valid params" do
        before do
          user = mock_user(:name => "alice")
          user.should_receive(:save).and_return { true }
          User.stub(:new).with( 'these' => 'params' ) { user }
        end

        it "assigns newly created user as @user" do
          post :create, :user => {'these' => 'params'}
          assigns(:user).should be(@mock_user)
        end

        it "redirects to the page for the created user" do
          post :create, :user => {'these' => 'params'}
          response.should redirect_to(user_path(@mock_user))
        end

        it "displays a success message" do
          post :create, :user => {'these' => 'params'}
          flash[:success].should == 'User alice has been created.'
        end

      end

      context "with invalid params" do
        before do
          user = mock_user(:name => "alice")
          user.should_receive(:save).and_return { false }
          User.stub(:new).with( 'these' => 'params' ) { user }
        end

        it "assigns newly created user as @user" do
          post :create, :user => {'these' => 'params'}
          assigns(:user).should be(@mock_user)
        end

        it "re-renders the new user view" do
          post :create, :user => {'these' => 'params'}
          response.should render_template('new')
        end

        it "displays an error message" do
          post :create, :user => {'these' => 'params'}
          flash[:error].should == 'There were errors in the information entered.'
        end

      end

    end

  end

end
