require File.expand_path(File.dirname(__FILE__) + '/acceptance_helper')

feature "Manage a post", %q{
  In order to manage journal
  As a author
  I want to create, update, destroy a post
} do

  background do
    setup_driver
  end

  scenario "create a post" do
    author = Factory(:author)

    sign_in

    visit post_new
    fill_in('Content', :with => 'Rule the world!')
    click_button('Create Post')

    visit homepage
    page.should have_content('Rule the world!')
  end

  scenario "update a post" do
    post = Post.create!(:content => 'Hacker and Painter')
    author = Factory(:author)

    sign_in

    visit post_edit(post)
    fill_in('Content', :with => 'Photoshop and Painter')
    click_button('Update Post')

    visit post_show(post)
    page.should have_content('Photoshop and Painter')
    page.should_not have_content('Hacker and Painter')
  end

  scenario "destroy a post" do
    post = Post.create!(:content => 'Deprecated content')
    author = Factory(:author)

    sign_in

    visit post_show(post)
    click_link('Delete')

    visit homepage
    page.should_not have_content('Deprecated content')
  end

end
