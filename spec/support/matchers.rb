RSpec::Matchers.define :be_valid do
  match do |model|
    model.valid?
  end

  failure_message_for_should do |model|
    "#{model.class} expected to be valid but had errors: #{model.errors.full_messages.join(", ")}"
  end

  failure_message_for_should_not do |model|
    "#{model.class} expected to have errors, but it did not"
  end

  description do
    "be valid"
  end
end

RSpec::Matchers.define :have_permissions do
  match do |model|
    manager = Factory(:manager)
    other_user = Factory(:user)
    
    ((model.changeable_by?(other_user) == false) &&
     (model.changeable_by?(model.user) == true) &&
     (model.changeable_by?(manager) == true) &&
     (model.changeable_by?(nil) == false))
  end

  failure_message_for_should do |model|
    "#{model.class} expected to know who has permissions to change it but didn't"
  end

  description do
    "should know who has permissions to change it"
  end
end
