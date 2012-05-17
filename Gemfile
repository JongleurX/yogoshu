source 'http://rubygems.org'

gem 'rails', "3.2.1"

gem 'haml'
gem 'rails_autolink'
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git'
gem 'thin'
gem 'rails3-jquery-autocomplete'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier'
  gem 'bootstrap-sass', '~> 2.0.1', :branch => '2.0'
end

group :test do
  gem 'rake'
  gem 'rspec-rails'
  gem 'cucumber-rails', '~> 1.3', require: false
end

group :test, :development do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit', :git => 'https://github.com/thoughtbot/capybara-webkit.git'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'
  gem 'simplecov', :require => false
#  gem 'ruby-debug-base19x', '0.11.30.pre10'
  gem 'debugger'
  gem 'database_cleaner'
  gem 'capybara'
end

gem 'jquery-rails'
gem 'twitter_bootstrap_form_for', :git => 'git://github.com/stouset/twitter_bootstrap_form_for.git', :branch => 'bootstrap-2.0'
gem 'kaminari'

group :production do
  gem 'mysql2'
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

