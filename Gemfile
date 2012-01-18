source 'http://rubygems.org'

gem 'rails', :git => 'git://github.com/rails/rails.git', :branch=>'3-1-stable'

gem 'haml'
gem 'twitter_bootstrap_form_for'
gem 'rails_autolink'
gem 'globalize3', :git => 'git://github.com/svenfuchs/globalize3.git'
gem 'thin'
gem 'rails3-jquery-autocomplete'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
  gem 'bootstrap-sass'
end

group :test do
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-jasmine'
  gem 'guard-cucumber'
end

group :test, :development do
  gem 'sqlite3'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'jasmine'
  gem 'jasminerice'
  gem 'spork', '~> 0.9.0.rc'
  gem 'launchy'
  gem 'ruby-debug19'
  gem 'libnotify'
  gem 'simplecov', :require => false
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

group :production do
  gem 'pg'
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

