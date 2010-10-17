require 'spec_helper'

describe "posts/show.html.erb" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
