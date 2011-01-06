module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end

  def post_create
    '/posts'
  end
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance






