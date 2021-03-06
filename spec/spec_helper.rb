unless ENV['CI']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'capybara/rails'
  require 'factory_girl'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
#    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # ref: https://github.com/bogdan/accept_values_for/blob/master/spec/spec_helper.rb & https://github.com/svenfuchs/globalize3/blob/master/test/globalize3/validations_test.rb
    ActiveRecord::Schema.define do
      create_table :validatees, :force => true do |t|
      end

      create_table :validatee_translations, :force => true do |t|
        t.references :validatee
        t.string :locale
        t.string :string
      end
    end 

  end 
end

Spork.each_run do
  # This code will be run each time you run your specs.
  # reload app sources

  silence_warnings do
    Dir[Rails.root.join('lib/**/*.rb')].each do |file|
      load file
    end
    Dir[Rails.root.join('app/**/*.rb')].each do |file|
      load file
    end
  end 

end
