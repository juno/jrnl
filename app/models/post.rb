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
  rescue => e
    "Couldn't parse content as HTML: #{e}"
  end

  # @return [String]
  def title
    first_line = ActionController::Base.helpers.strip_tags(html).split("\n").first
    str = first_line.split(//).first(30).inject('') { |result, char| result += char }
    str += '...' if first_line.length > 30
    str
  end
end
