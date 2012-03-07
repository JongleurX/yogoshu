# -*- coding: utf-8 -*-

FactoryGirl.define do
  sequence :name do |n|
    "foo#{n}" 
  end

  factory :user do
    name
    password "foobar"
    password_confirmation { |u| u.password }
    role "contributor"
  end

  factory :manager, :parent => :user do
    name 'manager_user'
    password 'secret'
    role "manager"
  end

  factory :entry do
    user
    note 'MyString'
    approved false
  end

  [:en, :ja].each do |lang|
    eval <<-RUBY_END
    factory :entry_#{lang}, :class => Entry do
      sequence(:term_in_#{lang}) { |n| "term\#{n}" }
      user
    end
    RUBY_END
  end
end
