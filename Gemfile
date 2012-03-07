source 'http://rubygems.org'

gem 'rails', "3.2.1"

gem 'haml'
gem 'rails_autolink'
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git'
gem 'thin'
gem 'rails3-jquery-autocomplete'
gem 'best_in_place', :git => 'git://github.com/bernat/best_in_place.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier'
  gem 'bootstrap-sass', '~> 2.0.1', :branch => '2.0'
end

group :test do
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-jasmine'
  gem 'guard-cucumber'
  gem 'rake'
end

group :test, :development do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit', :git => 'https://github.com/thoughtbot/capybara-webkit.git'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'
  gem 'libnotify'
  gem 'simplecov', :require => false
  gem 'ruby-debug19', :require => 'ruby-debug'
end

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'
end

gem 'jquery-rails'
gem 'twitter_bootstrap_form_for', :git => 'git://github.com/stouset/twitter_bootstrap_form_for.git', :branch => 'bootstrap-2.0'
gem 'kaminari'

group :production do
  gem 'pg'
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

