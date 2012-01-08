# -*- coding: utf-8 -*-

Factory.define :user do |f|
  f.sequence(:name) { |n| "foo#{n}" }
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.role "contributor"
end

Factory.define :alice, :class => User do |u|
  u.name 'alice'
  u.password 'wonderland'
  u.password_confirmation 'wonderland'
  u.role "contributor"
end

Factory.define :bob, :class => User do |u|
  u.name 'bob'
  u.password 'abcdef'
  u.password_confirmation 'abcdef'
  u.role "contributor"
end

Factory.define :manager, :class => User do |u|
  u.name 'manager_user'
  u.password 'secret'
  u.password_confirmation 'secret'
  u.role "manager"
end

[:en, :ja].each do |lang|
  eval <<-RUBY_END
  Factory.define :entry_#{lang}, :class => Entry do |f|
    f.sequence(:term_in_#{lang}) { |n| "term\#{n}" }
    f.association :user, :factory => :user
  end
  RUBY_END
end
