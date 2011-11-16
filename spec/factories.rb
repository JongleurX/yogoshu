Factory.define :user do |f|
  f.sequence(:name) { |n| "foo#{n}" }
  f.password "foobar"
#  f.password_confirmation { |u| u.password }
  f.role "user"
end
