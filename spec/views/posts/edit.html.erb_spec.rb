require 'spec_helper'

describe "posts/edit.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :new_record? => false,
      :content => "MyText"
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => post_path(@post), :method => "post" do
      assert_select "textarea#post_content", :name => "post[content]"
    end
  end
end
