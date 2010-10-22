class DeletePostsContentIndex < ActiveRecord::Migration
  def self.up
    remove_index :posts, :content
  end

  def self.down
    add_index :posts, :content
  end
end
