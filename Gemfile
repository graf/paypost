source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'jbuilder', '~> 2.7'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
gem 'webpacker', '~> 4.0'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'devise'
gem 'devise_token_auth'
gem 'slim-rails'
gem 'clockwork'

group :development, :test do
  gem 'byebug'
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'capybara'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'simplecov', require: false
end
