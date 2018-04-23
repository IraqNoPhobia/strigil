FactoryBot.define do
  factory :reddit_comment, class: Strigil::RedditComment do
    post_id 't1_c762re1'
    username 'testname'
    subreddit 'test'
    posted_at Time.new(2018, 4, 11, 12, 0, 0, '-04:00')
    content 'example content'
    permalink 'https://www.reddit.com/r/strigil/comments/13pnu0/no_way/c762re1/'
  end

  factory :reddit_comment2, class: Strigil::RedditComment do
    post_id 't1_c762re2'
    username 'testname'
    subreddit 'test'
    posted_at Time.new(2018, 4, 11, 12, 0, 0, '-04:00')
    content 'example content 2'
    permalink 'https://www.reddit.com/r/strigil/comments/13pnu0/no_way/c762re2/'
  end

  factory :real_reddit_comment, class: Strigil::RedditComment do
    post_id 't1_dx6z3c9'
    username 'strigiltest'
    subreddit 'test'
    posted_at Time.new(2018, 5, 11, 11, 0, 1, '-04:00')
    content 'test comment content'
    permalink 'https://www.reddit.com/r/test/comments/8bioy2/test_post_title/dx6z3c9/'
  end
end
