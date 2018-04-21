class AddIndexToRedditComments < ActiveRecord::Migration[5.2]
  def change
    change_table :reddit_comments do |t|
      t.index :post_id, unique: true
      t.index :permalink, unique: true
      t.index :subreddit
      t.index :username
    end
  end
end
