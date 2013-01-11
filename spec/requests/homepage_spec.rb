# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Homepage" do

  describe "Show recent 5 posts" do
    before do
      (1..6).each { |i| FactoryGirl.create(:post, :content => "Post #{i}") }
      visit root_path
    end
    subject { page }
    it { should_not have_content('Post 1') }
    (2..6).each { |i|
      it { should have_content("Post #{i}") }
    }
  end

  describe "Show particular post" do
    let(:post) { FactoryGirl.create(:post, :content => 'Red, Green, Blue') }
    before { visit post_path(post) }
    subject { page }
    it { should have_content('Red, Green, Blue') }
  end

end
