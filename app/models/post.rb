class Post < ActiveRecord::Base
  validates :content, :presence => true

  # @return [String]
  def html
    BlueFeather.parse(self.content)
  end

  # @return [String]
  def title
      ActionController::Base.helpers.strip_tags(html).split("\n").first.split(//).first(30).inject('') do |result, char|
      result += char
    end
  end
end
