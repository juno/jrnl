ENV["RAILS_ENV"] ||= "test"

require "simplecov"
require "simplecov-rcov"
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

require File.expand_path("../config/environment", __dir__)
require "rspec/rails"

#
# shoulda-matchers
#
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec

    # Choose one or more libraries:
    with.library :active_record
    with.library :active_model
    with.library :action_controller
  end
end

Rails.root.glob("spec/support/**/*.rb").each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.fixture_paths = Rails.root.join("spec/fixtures").to_s
  config.use_transactional_fixtures = true

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::ControllerHelpers, type: :controller
end
