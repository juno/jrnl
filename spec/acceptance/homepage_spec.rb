require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Homepage", %q{
  In order to browse journal
  As a visitor
  I want to view posts
} do

  scenario "should show recent 5 posts" do
    (1..6).each { |i| Factory(:post, :content => "Post #{i}") }
    visit homepage
    (2..6).each { |i| page.should have_content("Post #{i}") }
    page.should_not have_content('Post 1')
  end

end
