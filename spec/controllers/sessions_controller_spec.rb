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

    it "should assign @current_user" do
      assigns(:current_user).should be(@user)
    end

    it "should set the session cookie" do
      session[:user].should == @user.name
    end

    it "should redirect to the homepage" do
      response.should redirect_to(homepage_path)
    end

    it "should notify the user that they have successfully logged in"
  end

  describe "unsuccessful login" do
    before do
      User.should_receive(:authenticate).and_return { nil }
      post :create, :user => { 'these' => 'params' }
    end

    it "should not assign @current_user" do
      assigns(:current_user).should be_nil
    end

    it "should not set the session cookie" do
      session[:user].should be_nil
    end

    it "should re-render the login page" do
      response.should render_template('new')
    end

    it "should return an error message"

  end

  describe "logout" do
    before do
      post :create, :user => { :name => @user.name, :password => @user.password }
      #visit login_path
      #save_and_open_page
      #fill_in('User name', :with => @user.name)
      #fill_in('Password', :with => @user.password)
      #click_button('Login')
    end

    pending "should unset the session cookie" do
      visit logout_path
      session[:user].should be_nil
    end

    pending "should unassign @current_user" do
      visit logout_path
      assigns(:current_user).should be_nil
    end

    it "should redirect to the homepage" do
      response.should redirect_to(homepage_path)
    end

  end

end
