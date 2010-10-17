module ApplicationHelper
  # @param [String] title
  # @param [String] prefix
  def title(title, prefix = 'Sooey - ')
    content_for(:title) { "#{prefix}#{title}" }
  end
end






