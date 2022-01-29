require "spec_helper"

RSpec.describe "Manage posts", type: :feature do
  include RequestSpecHelper

  context "Not signed in" do
    describe "Can't post an article" do
      subject { page }

      before { visit new_post_path }

      describe "#current_path" do
        subject { super().current_path }

        it { is_expected.to eq(new_user_session_path) }
      end
    end

    describe "Can't update an article" do
      subject { page }

      let(:post) { create(:post) }

      before { visit edit_post_path(post) }

      describe "#current_path" do
        subject { super().current_path }

        it { is_expected.to eq(new_user_session_path) }
      end
    end
  end

  context "Signed in" do
    let!(:author) { create(:author) }

    before { sign_in(author.email, "secret-phrase") }

    after do
      # Destory current session
      visit admin_path
      click_link "Sign out"
    end

    describe "Can post an article" do
      subject { page }

      before do
        visit admin_path
        click_link "New post"
        fill_in("Content", with: "Rule the world!")
        click_button "Create Post"
        visit root_path
      end

      it { is_expected.to have_content("Rule the world!") }
    end

    describe "Can update an article" do
      subject { page }

      let!(:post) { create(:post, content: "Hacker and Painter") }

      before do
        visit admin_path
        find("#post_#{post.id}").click_link("Edit")
        fill_in("Content", with: "Photoshop and Painter")
        click_button("Update Post")
        visit post_path(post)
      end

      it { is_expected.to have_content("Photoshop and Painter") }
      it { is_expected.not_to have_content("Hacker and Painter") }
    end

    describe "Can destroy an article" do
      subject { page }

      let!(:post) { create(:post, content: "Deprecated content") }

      before do
        visit admin_path
        find("#post_#{post.id}").click_link("Delete")
        visit root_path
      end

      it { is_expected.not_to have_content("Deprecated content") }
    end
  end
end
