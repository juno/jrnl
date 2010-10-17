class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.text :content

      t.timestamps
    end

    add_index :posts, :content
  end

  def self.down
    remove_index :posts, :content

    drop_table :posts
  end
end
