class Post < ActiveRecord::Base
  validates :content, :presence => true

  # @return [String]
  def html
    BlueFeather.parse(self.content)
  end

  # @return [String]
  def title
    self.content.split("\n").first.split(//).first(30).inject('') do |result, char|
      result += char
    end
  end
end
