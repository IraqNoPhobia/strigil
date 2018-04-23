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

    def archive(permalinks)
      to_queue = find_to_queue(permalinks)

      to_queue.each do |permalink|
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

    private

    def find_to_queue(permalinks)
      permalinks = [permalinks] unless permalinks.class == Array

      to_queue = permalinks.reject { |n| RedditController.pool.include?(n) }
      already_in_db = Strigil::RedditComment.where(permalink: to_queue).map(&:permalink)
      to_queue.reject { |n| already_in_db.include?(n) }
    end
  end
end
