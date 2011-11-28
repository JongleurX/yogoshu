require 'spec_helper'

describe User do

  describe "validation" do

    subject { User.new }

    describe "should have name" do 

      before { subject.password = subject.password_confirmation = 'abcdefg' }

      it "should be invalid without name" do
        subject.should_not be_valid
      end

      it "should be valid with a name given" do
        subject.name = 'bob'
        subject.should be_valid
      end

      before { Factory(:user, :name => "alice") }

      it "should be invalid with name already taken" do
        subject.name = 'alice'
        subject.should_not be_valid
        subject.name = 'bob'
        subject.should be_valid
      end

      it "should be invalid without a role"

    end

    describe "should have password" do 

      before { subject.name = 'bob' }

      it("should be invalid without password") do
        subject.should_not be_valid
      end

      it("should be invalid without password confirmation matched") do
        subject.password = 'abcdefg'
        subject.password_confirmation = 'abcdef'
        subject.should_not be_valid
      end

      it("should be invalid with an empty password") do
        subject.password = subject.password_confirmation = ''
        subject.should_not be_valid
      end

      it("should be invalid with nil password confirmation") do
        subject.password = 'abcdefg'
        subject.should_not be_valid
      end

      it("should be valid with a proper password") do
        subject.password = subject.password_confirmation = 'abcdefg'
        subject.should be_valid
      end

    end

  end

end
