require 'snoo'
require 'date'

class RedditParser
  attr_accessor :subreddit

  def initialize
    @reddit = Snoo::Client.new
    @subreddit = "gaming"
    @last_api_call_time = Time.now
    @delay_since_last_api_call = 2
  end

  def delay
    @delay_since_last_api_call = Time.now - @last_api_call_time
    sleep 2 - @delay_since_last_api_call if @delay_since_last_api_call < 2
    @last_api_call_time = Time.now
  end
  
  def link_ids
    start = Time.now
    puts "link_ids start"
    ids = (@reddit.get_listing subreddit: subreddit)["data"]["children"]
      .map{ |link| link["data"]["id"] }
    delay
    puts "link_ids finished: #{Time.now - start}"
    ids
  end

  def get_post link_id
    start = Time.now
    puts "get_post start"
    post = @reddit.get_comments link_id: link_id, limit: 1000
    delay
    puts "get_post finished: #{Time.now - start}"
    post
  end

  def comments_from post
    post[1]["data"]["children"]
  end

  def flatten_threaded_comments comments
    start = Time.now
    puts "flatten_threaded_comments start"
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
            all_comments << { 
                              body: v["body"], 
                              id: v["id"], 
                              commented_on: Time.at(v["created"]).to_datetime
                            } unless v.nil? || v["body"].nil?
          end
          stack << k if k.is_a?(Array) || k.is_a?(Hash)
        end
      end
    end
    puts "flatten_threaded_comments finished: #{Time.now - start}"
    all_comments
  end

  def all_comments_flattened
    puts "all_comments_flattened start"
    link_ids.map do |link_id| 
      flatten_threaded_comments comments_from get_post link_id
    end.flatten
  end
end
