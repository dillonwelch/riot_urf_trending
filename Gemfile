source 'https://rubygems.org'

ruby File.read("#{Dir.pwd}/.ruby-version").chomp

gem 'rails', '4.2.0'

gem 'bootstrap-sass'
gem 'clockwork'
gem 'coffee-rails', '~> 4.1.0'
gem 'chart-js-rails'
gem 'dalli'
gem 'dotenv-rails', require: 'dotenv-rails'
gem 'haml-rails'
gem 'jbuilder', '~> 2.0'
gem 'jquery-rails'
gem 'memcachier'
gem 'pg'
gem 'ruby-lol', require: 'lol'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

group :doc do
  gem 'sdoc', '~> 0.4.0'
end

group :development, :test do
  gem 'byebug', github: 'deivid-rodriguez/byebug', branch: 'master'
  gem 'spring'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter', git:'git@github.com:circleci/rspec_junit_formatter.git'
  gem 'shoulda-matchers'
end

group :production do
  gem 'rails_12factor'
end
