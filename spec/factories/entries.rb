# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    note "MyString"
    approved false
  end
end
