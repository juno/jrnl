require 'spec_helper'

describe Post do

  describe '#html' do
    context 'when content is valid Markdown format' do
      before(:each) do
        @content = '[Example](http://example.com/)'
      end

      it 'returns content as HTML' do
        Post.new(:content => @content).html.should eq('<p><a href="http://example.com/">Example</a></p>')
      end
    end

    context 'when content is invalid Markdown format' do
      before(:each) do
        BlueFeather.stub(:parse).and_raise(RuntimeError.new('Parse error'))
      end

      it 'returns error message' do
        Post.new.html.should eq("Couldn't parse content as HTML: Parse error")
      end
    end
  end

  describe '#title' do
    context 'when length of first line less than 31' do
      it 'returns first line of content' do
        Post.new(:content => "First line\nSecond line.").title.should eq('First line')
      end

      it 'returns plain text' do
        Post.new(:content => "*Foo*").title.should eq('Foo')
      end
    end

    context 'when length of first line greater than 30' do
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
