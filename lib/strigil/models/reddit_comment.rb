module Strigil
  class RedditComment < ActiveRecord::Base
    validates :post_id, :permalink, uniqueness: true
    validates :post_id, :permalink, :username, :posted_at, :content, :subreddit,
              presence: true
  end
end
