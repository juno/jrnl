# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Manage posts" do

  include RequestSpecHelper

  after { visit destroy_user_session_path }

  context "Not signed in" do
    describe "Can't post an article" do
      before { visit new_post_path }
      subject { page }
      its(:current_path) { should eq(new_user_session_path) }
    end

    describe "Can't update an article" do
      let(:post) { Factory(:post) }
      before { visit edit_post_path(post) }
      subject { page }
      its(:current_path) { should eq(new_user_session_path) }
    end
  end

  context "Signed in" do
    let!(:author) { Factory(:author) }
    before { sign_in(author.email, 'secret-phrase') }

    describe "Can post an article" do
      before do
        visit admin_path
        click_link 'New post'
        fill_in('Content', :with => 'Rule the world!')
        click_button 'Create Post'
        visit root_path
      end
      subject { page }
      it { should have_content('Rule the world!') }
    end

    describe "Can update an article" do
      let!(:post) { Factory(:post, :content => 'Hacker and Painter') }
      before do
        visit admin_path
        find("#post_#{post.id}").click_link('Edit')
        fill_in('Content', :with => 'Photoshop and Painter')
        click_button('Update Post')
        visit post_path(post)
      end
      subject { page }
      it { should have_content('Photoshop and Painter') }
      it { should_not have_content('Hacker and Painter') }
    end

    describe "Can destroy an article" do
      let!(:post) { Factory(:post, :content => 'Deprecated content') }
      before do
        visit admin_path
        find("#post_#{post.id}").click_link('Delete')
        visit root_path
      end
      subject { page }
      it { should_not have_content('Deprecated content') }
    end
  end

end
