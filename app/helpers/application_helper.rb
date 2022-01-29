# Application helper
module ApplicationHelper
  # @param [String] title
  # @param [String] prefix
  def title(title, suffix = " - Sooey")
    content_for(:title) { "#{title}#{suffix}" }
  end
end
