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
    max_length = 70
    first_line = ActionController::Base.helpers.strip_tags(html).split("\n").first
    str = first_line.split(//).first(max_length).inject('') { |result, char| result += char }
    str += '...' if first_line.length > max_length
    str
  end
end
