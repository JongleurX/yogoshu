# -*- coding: utf-8 -*-

FactoryGirl.define do
  sequence :name do |n|
    "foo#{n}" 
  end

  sequence :term do |n|
    "term#{n}"
  end

  Yogoshu::Locales.base_languages.each do |lang|
    sequence(:"term_in_#{lang}") { |n| "term_in_#{lang}_#{n}" }
  end

  sequence(:term_in_glossary_language) { FactoryGirl.generate(:term) }

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

  # default factory creates an entry with a term in the glossary language
  factory :entry do
    user
    term_in_glossary_language
    note 'a note'
  end

  # language-specific factories create entry with glossary language term + term in language
  Yogoshu::Locales.base_languages.each do |lang|
  eval <<-END_RUBY
    factory :entry_#{lang}, :class => Entry, :parent => :entry do
      term_in_#{lang}
    end
  END_RUBY
  end

end
