module Strigil
  class RedditWorker < Worker
    # Able to pass a fake client class for testing
    def initialize(fake_client = nil)
      @client = fake_client || RedditWebClient
    end

    # Ensuring comment doesn't already exist _must_ take place before calling
    def perform(permalink)
      RedditController.pool.delete(permalink)
      begin
        params = @client.permalink_to_json(permalink)
      rescue CommentRemovedError
        puts '---------------'
        puts "Comment #{permalink} removed or inaccessible"
        puts '---------------'
        return
      end
      RedditComment.create(params)
    end
  end
end
