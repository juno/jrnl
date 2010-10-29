class Post < ActiveRecord::Base
  validates :content, :presence => true

  # @param [Integer] page
  # @return [Array]
  def self.search(page)
    paginate :per_page => 5, :page => page, :conditions => ['draft is ?', false], :order => 'created_at DESC'
  end

  # @return [String]
  def html
    BlueFeather.parse(self.content)
  end

  # @return [String]
  def title
    self.content.split("\n").first.split(//).first(15).inject('') do |result, char|
      result += char
    end
  end
end
