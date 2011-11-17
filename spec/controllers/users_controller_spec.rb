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

    describe "GET show" do
      before do
        user = mock_user
        user.stub(:id) { "37" }
        User.should_receive(:find_by_name!).and_return { user }
      end

      it "assigns the requested user as @user" do
        get :show, :locale => 'en', :id => "susan"
        assigns(:user).should be(@mock_user)
      end
    end

  end

end
