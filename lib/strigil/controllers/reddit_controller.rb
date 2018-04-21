# Controller for Reddit Target
module Strigil
  class RedditController < Controller
    @@pool = Set.new
    attr_reader :target

    def self.pool
      @@pool
    end

    def initialize(target)
      @target = target
    end

    def archive(permalink)
      unless RedditController.pool.include?(permalink) || RedditComment.exists?(permalink: permalink)
        RedditController.pool.add(permalink)
        RedditWorker.perform_async(permalink)
      end
    end

    def begin_archive
      # TODO: Break up the get_comment_permalinks to return one at a time and pass to archives
      permalinks = RedditWebClient.get_comment_permalinks(target)
      permalinks.each { |link| archive(link) }
      permalinks.count
    end
  end
end
