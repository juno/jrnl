# Post model
class Post < ActiveRecord::Base
  validates :content, presence: true

  scope :created_within, -> from, to { where(created_at: from..to) }
  scope :oldest, -> { order('created_at') }
  scope :recent, -> { order('created_at DESC') }

  # @return [String]
  def html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content)
  rescue => e
    "Couldn't parse content as HTML: #{e}"
  end

  # @return [String]
  def title
    max_length = 70
    first_line = ActionController::Base.helpers
      .strip_tags(html)
      .split("\n")
      .first
    str = first_line.split(//).first(max_length).reduce('') { |a, e| a + e }
    str += '...' if first_line.length > max_length
    str
  end
end
