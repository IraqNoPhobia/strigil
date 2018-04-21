class InitializeDb < ActiveRecord::Migration[5.2]
  def change
    create_table :reddit_comments do |t|
      t.string    :post_id
      t.string    :username
      t.timestamp :posted_at
      t.text      :content
      t.string    :permalink
      t.string    :subreddit

      t.timestamps
    end
  end
end
