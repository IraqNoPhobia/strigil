module Strigil
  class RedditWorker < Worker
    # Able to pass a fake client class for testing
    def initialize(fake_client = nil)
      @requester_class = fake_client || RedditWebClient
    end

    def perform(permalink)
      unless RedditComment.exists?(permalink: permalink)
        RedditController.pool.delete(permalink)
        begin
          params = @requester_class.permalink_to_json(permalink)
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
end
