# Post model
class Post < ApplicationRecord
  validates :content, presence: true

  scope :created_within, ->(from, to) { where(created_at: from..to) }
  scope :oldest, -> { order("created_at") }
  scope :recent, -> { order("created_at DESC") }

  # @return [String]
  def html
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content)
  rescue StandardError => e
    "Couldn't parse content as HTML: #{e}"
  end

  # @return [String]
  def title
    max_length = 70
    first_line = ActionController::Base.helpers
      .strip_tags(html)
      .split("\n")
      .first
    str = first_line[0..max_length - 1]
    str += "..." if first_line.length > max_length
    str
  end
end
