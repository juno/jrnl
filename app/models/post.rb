class Post < ActiveRecord::Base
  validates :content, :presence => true

  scope :created_within, lambda { |from, to|
    where(:created_at => from..to)
  }
  scope :oldest, order("posts.created_at ASC")
  scope :recent, order("posts.created_at DESC")

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
