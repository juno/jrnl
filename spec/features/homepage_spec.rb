# -*- coding: utf-8 -*-

require 'spec_helper'

describe "Homepage", :type => :feature do

  describe "Show recent 5 posts" do
    before do
      (1..6).each { |i| FactoryBot.create(:post, :content => "Post #{i}") }
      visit root_path
    end
    subject { page }
    it { is_expected.not_to have_content('Post 1') }
    (2..6).each { |i|
      it { is_expected.to have_content("Post #{i}") }
    }
  end

  describe "Show particular post" do
    let(:post) { FactoryBot.create(:post, :content => 'Red, Green, Blue') }
    before { visit post_path(post) }
    subject { page }
    it { is_expected.to have_content('Red, Green, Blue') }
  end

end
