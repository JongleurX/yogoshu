require 'spec_helper'

describe SessionsController do
  before do
    @user = Factory(:user)
  end

  describe "successful login" do
    before do
      User.should_receive(:authenticate).and_return { @user }
      post :create, :user => { 'these' => 'params' }
    end

    it "should set the session cookie" do
      session[:user].should == @user.name
    end

    it "should redirect to the homepage" do
      response.should redirect_to(homepage_path)
    end

    it "should welcome the user back" do
      flash[:message].should include "Welcome back #{@user.name}!"
    end

  end

  describe "unsuccessful login" do
    before do
      User.should_receive(:authenticate).and_return { nil }
      User.stub(:new) { mock_model(User) }
      post :create, :user => { 'these' => 'params' }
    end

    it "should not set the session cookie" do
      session[:user].should be_nil
    end

    it "should re-render the login page" do
      response.should render_template('new')
    end

    it "should return an error message" do
      flash[:error].should == "Username or password incorrect. Please try again."
    end

  end

  describe "logout" do
    before do
      post :create, :user => { :name => @user.name, :password => @user.password }
      post :destroy
    end

    it "should unset the session cookie" do
      session[:user].should be_nil
    end

    it "should not set @current_user" do
      @current_user.should be_nil
    end

    it "should redirect to the homepage" do
      response.should redirect_to(homepage_path)
    end

    it "should alert the user that they are logged out" do
      flash[:message].should include("logged out")
    end

  end

end
