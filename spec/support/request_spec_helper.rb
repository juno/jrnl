# Test helpers for request spec
module RequestSpecHelper
  # Sign in.
  #
  # @param [String] email
  # @param [String] password
  def sign_in(email, password)
    visit new_user_session_path
    fill_in("Email", with: email)
    fill_in("Password", with: password)
    click_button("Sign in")
  end
end
