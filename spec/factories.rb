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
  u.role 1 # ROLES[1] = "contributor"
end

Factory.define :entry_en, :class => Entry do |f|
  f.source_language 'en'
  Globalize.with_locale(:en) do
    f.sequence(:term) { |n| "entry#{n}" }
  end
  f.association :user, :factory => :alice
end
