module HelperMethods

  def setup_driver
    @driver = Capybara.current_session.driver
  end

  def post(path, params = {})
    @driver.process :post, path, params
  end

  def put(path, params = {})
    @driver.process :put, path, params
  end

  def delete(path, params = {})
    @driver.process :delete, path, params
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance
