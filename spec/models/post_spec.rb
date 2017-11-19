require 'spec_helper'

describe Post, :type => :model do

  def setup_post_fixtures
    FactoryBot.create(:post, :created_at => Time.new(2010, 12, 31), :content => 'oldest one')
    FactoryBot.create(:post, :created_at => Time.new(2011, 1, 1))
    FactoryBot.create(:post, :created_at => Time.new(2011, 1, 31))
    FactoryBot.create(:post, :created_at => Time.new(2011, 2, 1))
    FactoryBot.create(:post, :created_at => Time.new(2011, 2, 2), :content => 'newest one')
  end

  it { is_expected.to validate_presence_of :content }

  describe '.created_within' do
    before { setup_post_fixtures }
    let(:beginning_of_month) { Time.new(2011, 1, 10).beginning_of_month }
    let(:end_of_month) { Time.new(2011, 1, 10).end_of_month }
    subject { Post.created_within(beginning_of_month, end_of_month) }
    it 'has 2 posts' do
      expect(subject.size).to eq(2)
    end
  end

  describe '.oldest' do
    before { setup_post_fixtures }
    subject { Post.oldest }
    it 'has 5 posts' do
      expect(subject.size).to eq(5)
    end

    describe '#first' do
      subject { super().first }
      describe '#content' do
        subject { super().content }
        it { is_expected.to eq('oldest one') }
      end
    end

    describe '#last' do
      subject { super().last }
      describe '#content' do
        subject { super().content }
        it { is_expected.to eq('newest one') }
      end
    end
  end

  describe '.recent' do
    before { setup_post_fixtures }
    subject { Post.recent }
    it 'has 5 posts' do
      expect(subject.size).to eq(5)
    end

    describe '#first' do
      subject { super().first }
      describe '#content' do
        subject { super().content }
        it { is_expected.to eq('newest one')}
      end
    end

    describe '#last' do
      subject { super().last }
      describe '#content' do
        subject { super().content }
        it { is_expected.to eq('oldest one')}
      end
    end
  end

  describe '#html' do
    context 'content contains valid Markdown' do
      let(:content) { '[Example](http://example.com/)' }
      subject { Post.new(:content => content).html }
      it { is_expected.to eq("<p><a href=\"http://example.com/\">Example</a></p>\n") }
    end

    context 'content contains invalid Markdown' do
      let(:content) { '[Example](http://example' }
      subject { Post.new.html }
      it { is_expected.to match(/^Couldn't parse content as HTML: .+/) }
    end
  end

  describe '#title' do
    context 'length of first line less than 71' do
      let(:content) { "*First* line\nSecond line." }
      subject { Post.new(:content => content).title }
      it { is_expected.to match(/^First /) }
      it { is_expected.not_to match(/\n/) }
    end

    context 'length of first line greater than 70' do
      let(:content) { '*a*' + ('b' * 70) }
      subject { Post.new(:content => content).title }
      it { is_expected.to match(%r|...$|) }
      it { is_expected.not_to match(/<em>/) }

      describe '#length' do
        subject { super().length }
        it { is_expected.to eq(70 + 3) }
      end
    end
  end

end
