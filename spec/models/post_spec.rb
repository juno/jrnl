require 'spec_helper'

describe Post do

  def setup_post_fixtures
    Factory(:post, :created_at => Time.new(2010, 12, 31), :content => 'oldest one')
    Factory(:post, :created_at => Time.new(2011, 1, 1))
    Factory(:post, :created_at => Time.new(2011, 1, 31))
    Factory(:post, :created_at => Time.new(2011, 2, 1))
    Factory(:post, :created_at => Time.new(2011, 2, 2), :content => 'newest one')
  end

  describe '.created_within' do
    before { setup_post_fixtures }
    let(:beginning_of_month) { Time.new(2011, 1, 10).beginning_of_month }
    let(:end_of_month) { Time.new(2011, 1, 10).end_of_month }
    subject { Post.created_within(beginning_of_month, end_of_month) }
    it { should have(2).posts }
  end

  describe '.oldest' do
    before { setup_post_fixtures }
    subject { Post.oldest }
    it { should have(5).posts }
    its('first.content') { should eq('oldest one') }
    its('last.content') { should eq('newest one') }
  end

  describe '.recent' do
    before { setup_post_fixtures }
    subject { Post.recent }
    it { should have(5).posts }
    its('first.content') { should eq('newest one')}
    its('last.content') { should eq('oldest one')}
  end

  describe '#html' do
    context 'content contains valid Markdown' do
      let(:content) { '[Example](http://example.com/)' }
      subject { Post.new(:content => content).html }
      it { should eq('<p><a href="http://example.com/">Example</a></p>') }
    end

    context 'content contains invalid Markdown' do
      let(:content) { '[Example](http://example' }
      subject { Post.new.html }
      it { should match(/^Couldn't parse content as HTML: .+/) }
    end
  end

  describe '#title' do
    context 'length of first line less than 31' do
      let(:content) { "*First* line\nSecond line." }
      subject { Post.new(:content => content).title }
      it { should match(/^First /) }
      it { should_not match(/\n/) }
    end

    context 'length of first line greater than 30' do
      let(:content) { '*a*' + ('b' * 30) }
      subject { Post.new(:content => content).title }
      it { should match(%r|...$|) }
      it { should_not match(/<em>/) }
      its(:length) { should eq(30 + 3) }
    end
  end

end
