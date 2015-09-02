source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.3'
gem 'pg', '0.18.2'
gem 'jquery-rails', '4.0.4'

gem 'sass-rails', '5.0.3'
gem 'coffee-rails', '4.1.0'
gem 'uglifier', '2.7.2'

gem 'devise', '3.5.2'
gem 'devise-encryptable', '0.2.0'
gem 'kaminari', '0.16.3'
gem 'redcarpet', '3.3.2'
gem 'settingslogic', '2.0.9'
gem 'puma', '2.13.4'

group :production do
  gem 'heroku-deflater'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails', '3.3.2'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara', '2.4.4'
  gem 'factory_girl_rails', '4.5.0'
  gem 'shoulda-matchers', '2.8.0', require: false
  gem 'simplecov', '0.10.0', require: false
  gem 'simplecov-rcov', '0.2.3', require: false
end
