class DeletePostsContentIndex < ActiveRecord::Migration[4.2]
  def self.up
    remove_index :posts, :content
  end

  def self.down
    add_index :posts, :content
  end
end
