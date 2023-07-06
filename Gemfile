source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# ruby '2.7.2'
ruby File.read(".ruby-version").strip
# to avoid Psych::BadAlias errors after 3.1 upgrade
gem 'psych', '< 4'
gem 'bcrypt'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bootstrap'
# gem 'bootstrap-will_paginate', '1.0.0'
gem 'coffee-rails', '~> 5.0.0'
gem 'faker'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'rubocop-rails'
gem 'sass-rails', '>= 6'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'pagy'
# for copying to clipboard
gem 'clipboard-rails'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
