# -*- coding: utf-8 -*-

ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'shoulda'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.include Devise::TestHelpers, :type => :controller
end
