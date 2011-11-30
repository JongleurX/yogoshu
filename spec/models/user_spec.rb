require 'spec_helper'

describe User do

  describe "validation with factory" do

    before do
      @user = Factory(:user)
      Factory(:user, :name => "alice")
    end

    subject { @user }

    describe "user attributes" do

      it "should be valid created by factory" do
        should be_valid
      end

      it "should be invalid without a name" do
        subject.name = nil
        should_not be_valid
      end

      it "should be invalid with name already taken" do
        subject.name = 'alice'
        subject.should_not be_valid
        subject.name = 'bob'
        subject.should be_valid
      end

      it "should be invalid with an invalid name string" do
        subject.name = "-x**000"
        subject.should_not be_valid
      end

      it "should be invalid without a role" do
        subject.role = nil
        should be_invalid
      end

      it "should be invalid with an invalid role" do
        subject.role = "abc"
        should be_invalid
      end

    end

    describe "password" do

      before do
        # build does not save the record, which is important for testing passwords
        @user = Factory.build(:user, :password => nil, :password_confirmation => nil)
      end

      it "should be invalid without a password" do
        subject.should_not be_valid
      end

      it "should be valid with a matching password and confirmation password" do
        subject.password = 'abcdefg'
        subject.password_confirmation = 'abcdefg'
        subject.should be_valid
      end

      it "should be invalid without password confirmation matched" do
        subject.password = 'abcdefg'
        subject.password_confirmation = 'abcdef'
        subject.should_not be_valid
      end

      it "should be invalid with a short password" do
        subject.password = subject.password_confirmation = 'abc'
        subject.should_not be_valid
      end

      it "should be invalid with a long password" do
        subject.password = subject.password_confirmation = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        subject.should_not be_valid
      end

      it "should be invalid with nil password confirmation" do
        subject.password = 'abcdefg'
        subject.should_not be_valid
      end
      
    end

  end

end
