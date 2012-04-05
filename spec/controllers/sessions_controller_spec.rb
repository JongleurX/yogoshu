require 'spec_helper'

describe SessionsController do
  before do
    @user = FactoryGirl.create(:user)
  end

  describe "successful login" do
    before do
      User.should_receive(:authenticate).and_return { @user }
      post :create, :user => { 'these' => 'params' }
    end

    it "assigns @current_user" do
      assigns(:current_user).should be(@user)
    end

    it "sets the session cookie" do
      session[:user].should == @user.name
    end

    it "redirects to the homepage" do
      response.should redirect_to(homepage_path)
    end

    it "welcomes the user back" do
      flash[:message].should include "Welcome back #{@user.name}!"
    end

  end

  describe "unsuccessful login" do
    before do
      User.should_receive(:authenticate).and_return { nil }
      User.stub(:new) { mock_model(User) }
      post :create, :user => { 'these' => 'params' }
    end

    it "does not assign @current_user" do
      assigns(:current_user).should be_nil
    end

    it "does not set the session cookie" do
      session[:user].should be_nil
    end

    it "re-renders the login page" do
      response.should render_template('new')
    end

    it "returns an error message" do
      flash[:error].should == "Username or password incorrect. Please try again."
    end

  end

  describe "logout" do
    before do
      post :create, :user => { :name => @user.name, :password => @user.password }
      post :destroy
    end

    it "unsets the session cookie" do
      session[:user].should be_nil
    end

    it "does not set @current_user" do
      @current_user.should be_nil
    end

    it "redirects to the homepage" do
      response.should redirect_to(homepage_path)
    end

    it "alerts the user that they are logged out" do
      flash[:message].should include("logged out")
    end

  end

end
