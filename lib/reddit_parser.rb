require 'snoo'

class RedditParser
  attr_accessor :subreddit

  def initialize
    @reddit = Snoo::Client.new
    @subreddit = "gaming"
  end

  def link_ids
    (@reddit.get_listing subreddit: subreddit)["data"]["children"]
      .map{ |link| link["data"]["id"] }
  end

  def get_post link_id
    @reddit.get_comments link_id: link_id, limit: 1000
  end

  def comments_from post
    post[1]["data"]["children"]
  end

  def flatten_threaded_comments comments
    all_comments = Array.new
    stack = comments

    while !stack.empty?
      check_comments = stack.pop
      unless check_comments.nil? || check_comments.is_a?(String)
        check_comments.each do |k , v|
          if v.is_a? Hash
            stack << v["data"] unless v["data"].nil?
            stack << v["replies"] unless v["replies"].nil?
            stack << v["children"] unless v["children"].nil?
            all_comments << { body: v["body"], id: v["id"] } unless v.nil? || v["body"].nil?
          end
          stack << k if k.is_a?(Array) || k.is_a?(Hash)
        end
      end
    end
    all_comments
  end
end

