require 'spec_helper'

describe Post do

  describe '.created_within' do
    before do
      Factory.create(:post, :created_at => Time.new(2010, 12, 31))
      Factory.create(:post, :created_at => Time.new(2011, 1, 1))
      Factory.create(:post, :created_at => Time.new(2011, 1, 31))
      Factory.create(:post, :created_at => Time.new(2011, 2, 1))
    end

    it 'returns posts thath created within specified term' do
      t = Time.new(2011, 1, 10)
      Post.created_within(t.beginning_of_month, t.end_of_month).should have(2).posts
    end
  end

  describe '.oldest' do
    before do
      Factory.create(:post, :content => 'newest one', :created_at => 5.minutes.ago)
      Factory.create(:post, :created_at => 10.minutes.ago)
      Factory.create(:post, :content => 'oldest one', :created_at => 15.minutes.ago)
    end

    it 'returns all posts' do
      Post.oldest.should have(3).posts
    end

    it 'returns oldest post as first item' do
      Post.oldest.first.content.should eq('oldest one')
    end

    it 'returns newest post as last item' do
      Post.oldest.last.content.should eq('newest one')
    end
  end

  describe '.recent' do
    before do
      Factory.create(:post, :content => 'newest one', :created_at => 5.minutes.ago)
      Factory.create(:post, :created_at => 10.minutes.ago)
      Factory.create(:post, :content => 'oldest one', :created_at => 15.minutes.ago)
    end

    it 'returns all posts' do
      Post.recent.should have(3).posts
    end

    it 'returns newest post as first item' do
      Post.recent.first.content.should eq('newest one')
    end

    it 'returns oldest post as last item' do
      Post.recent.last.content.should eq('oldest one')
    end
  end

  describe '#html' do
    context 'content contains valid Markdown format' do
      subject { Post.new(:content => '[Example](http://example.com/)').html }
      it { should eq('<p><a href="http://example.com/">Example</a></p>') }
    end

    context 'content contains invalid Markdown format' do
      before do
        BlueFeather.stub(:parse).and_raise(RuntimeError.new('Parse error'))
      end

      subject { Post.new.html }
      it { should eq("Couldn't parse content as HTML: Parse error") }
    end
  end

  describe '#title' do
    context 'length of first line less than 31' do
      subject { Post.new(:content => "*First* line\nSecond line.").title }
      it { should match(/^First /) }
      it { should_not match(/\n/) }
    end

    context 'length of first line greater than 30' do
      it 'returns first 30 characters of content' do
        Post.new(:content => 'a' * 31).title.should eq(('a' * 30) + '...')
      end

      it 'returns plain text' do
        Post.new(:content => '*a*' + ('b' * 30)).title.should_not =~ /<em>/
      end

      it 'ends with ...' do
        Post.new(:content => 'a' * 31).title.should =~ /\.\.\.\z/
      end
    end
  end

end
