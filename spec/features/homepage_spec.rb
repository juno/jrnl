require "spec_helper"

describe "Homepage", type: :feature do
  describe "Show recent 5 posts" do
    subject { page }

    before do
      (1..6).each { |i| create(:post, content: "Post #{i}") }
      visit root_path
    end

    it { is_expected.not_to have_content("Post 1") }

    (2..6).each { |i|
      it { is_expected.to have_content("Post #{i}") }
    }
  end

  describe "Show particular post" do
    subject { page }

    let(:post) { create(:post, content: "Red, Green, Blue") }

    before { visit post_path(post) }

    it { is_expected.to have_content("Red, Green, Blue") }
  end
end
