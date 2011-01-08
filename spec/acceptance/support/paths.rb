module NavigationHelpers

  def homepage
    "/"
  end

  def post_new
    '/posts/new'
  end

  def post_create
    '/posts'
  end

  def post_edit(post)
    "/posts/#{post.id}/edit"
  end

  def post_show(post)
    "/#{post.id}"
  end

end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
