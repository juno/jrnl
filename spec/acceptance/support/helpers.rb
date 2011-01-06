module HelperMethods

  def sign_in
    visit '/users/sign_in'
    fill_in('Email', :with => 'john.smith@example.com')
    fill_in('Password', :with => 'secretphrase')
    click_button('Sign in')
  end

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
