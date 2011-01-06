require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Posts", %q{
  In order to manage posts
  As a author
  I want to create, update, delete a post
} do

  background do
    setup_driver
  end

  scenario "create a post" do
    
    sign_in(Factory(:author))
    params = { :post => { } }
    params[:post][:content] = 'Rule the world.'
    post('/posts', params)
    Post.count.should == 1
  end

end
