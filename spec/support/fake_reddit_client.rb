class FakeRedditWebClient
  def self.permalink_to_json(permalink)
    {
      post_id: 't1_c762re1',
      username: 'testname',
      posted_at: Time.new(2018, 4, 11, 12, 0, 0, '-04:00'),
      content: 'example content',
      permalink: permalink
    }
  end
end
