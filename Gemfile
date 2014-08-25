source 'https://rubygems.org'

gem 'rails', "3.2.19"

gem 'haml'
gem 'rails_autolink'
gem 'globalize', '~> 3.1.0', :git => 'https://github.com/globalize/globalize.git', :branch => '3-1-stable'
gem 'thin'
gem 'rails3-jquery-autocomplete'
gem 'bcrypt', :require => 'bcrypt' # For encrypting passwords

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
  # gem 'capybara-webkit', :git => 'https://github.com/thoughtbot/capybara-webkit.git'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'
  gem 'simplecov', :require => false
#  gem 'ruby-debug-base19x', '0.11.30.pre10'
  gem 'debugger' unless ENV['CI']
  gem 'database_cleaner'
  gem 'capybara'
  gem 'timecop'
end

gem 'jquery-rails', '~> 2.3.0' # https://github.com/activeadmin/activeadmin/issues/2232
gem 'twitter_bootstrap_form_for', :git => 'git://github.com/stouset/twitter_bootstrap_form_for.git', :branch => 'bootstrap-2.0'
gem 'kaminari'

group :production do
  # gem 'mysql2', :git => 'https://github.com/brianmario/mysql2'
  # gem 'pg'
  gem 'sqlite3'
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
gem 'debugger'

