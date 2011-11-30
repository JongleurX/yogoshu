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

    it "should redirect create, update & destroy requests to login page" do
      requests = 
        [
          proc {  post :create, :user => {'these' => 'params'} },
          proc {  put :update, :id => "37" },
          proc {  delete :destroy, :id => "37" },
      ]

      requests.each do |r|
        r.call
        response.should redirect_to(:controller => 'sessions', :action => 'new' )
      end
    end

    describe "GET show" do
      before do
        user = mock_user
        user.stub(:id) { "37" }
        User.should_receive(:find_by_name!).and_return { user }
      end

      it "assigns the requested user as @user" do
        get :show, :id => "susan"
        assigns(:user).should be(@mock_user)
      end
    end

  end

  context "with logged-in contributor" do

    before do
      user = mock_user(:role => "contributor")
      controller.stub(:current_user) { user }
    end

  end

  context "with logged-in manager" do

    before do
      user = mock_user(:role => "manager")
      controller.stub(:current_user) { user }
    end

    describe "POST create" do

      context "with valid params" do
        before do
          neta = mock_user(:name => "alice")
          neta.should_receive(:save).and_return { true }
          User.stub(:new).with( 'these' => 'params' ) { @mock_user }
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

    end

  end

end
