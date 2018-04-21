# HTTP Client for Reddit
require 'nokogiri'
require 'open-uri'
require 'time'

module Strigil
  class RedditWebClient < WebClient
    class << self
      def permalink_to_json(permalink)
        tail = tail_url(permalink)

        doc = new_request(permalink)

        begin
          comment = doc.css("div[data-permalink='#{tail}']").first

          comment_tagline = comment.css("p[class='tagline']").first
          post_time = comment_tagline.css('time').first[:datetime]

          content_area = comment.css("div[class='md']").first
        rescue NoMethodError
          raise CommentRemovedError
        end

        {
          post_id: comment['data-fullname'],
          username: comment['data-author'],
          posted_at: Time.parse(post_time),
          content: content_area.text,
          permalink: permalink,
          subreddit: comment['data-subreddit']
        }
      end

      def get_comment_permalinks(target, results = [], url = nil)
        url ||= target_url(target)

        begin
          doc = new_request(url)
        rescue OpenURI::HTTPError
          raise InvalidUserError
        end

        comment_permalinks = select_link_by_text(doc, 'permalink')
        next_link = select_link_by_text(doc, next_button).first

        results += comment_permalinks

        if next_link.nil? || RedditComment.exists?(permalink: comment_permalinks)
          return results
        else
          get_comment_permalinks(target, results, next_link)
        end
      end

      private

      def base_url
        'https://www.reddit.com'
      end

      def target_url(target)
        base_url + "/user/#{target}/comments"
      end

      def tail_url(permalink)
        permalink[base_url.length, permalink.length]
      end

      def select_link_by_text(object, text)
        object.css("a[text()='#{text}']").map { |o| o[:href] }
      end

      def next_button
        'next ›'
      end

      def request_headers
        {
          :read_timeout => 10,
          'User-Agent' => Strigil.configuration.user_agent,
          'Cookie' => 'over18=1;rloo=true;'
        }
      end

      def request_url(url)
        url = base_url + url unless url.include?(base_url)

        URI.encode(url)
      end

      def new_request(url)
        url = base_url + url unless url.include?(base_url)

        user_agent = Strigil.configuration.user_agent
        Nokogiri::HTML(
          open(
            request_url(url),
            request_headers
          )
        )
      end
    end
  end

  class CommentRemovedError < StandardError
  end
end
