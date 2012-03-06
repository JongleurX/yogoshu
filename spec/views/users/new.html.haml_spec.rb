require 'spec_helper'

describe "users/new" do

  context "English locale" do

    before do
      I18n.locale = 'en'
    end

    describe "new user form with no error msgs" do

      before do
        @user = stub_model(User).as_new_record
      end

      it "renders form"  do
        render
        rendered.should have_selector("form#new_user")
      end

      it "renders input fields" do
        render
        rendered.should have_selector("input[type='text'][name='user[name]']")
        rendered.should have_selector("input[type='password'][name='user[password]']")
        rendered.should have_selector("input[type='password'][name='user[password_confirmation]']")
        rendered.should have_selector("button[type='submit']")
      end

      pending "should have role selector field" do
        render
        rendered.should have_selector("input[type='select'][name='user[role]']")
      end

    end

  end

end
