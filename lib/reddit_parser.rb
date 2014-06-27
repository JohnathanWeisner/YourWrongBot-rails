require 'snoo'

class RedditParser
  attr_accessor :subreddit

  def initialize(args)
    @reddit = args.fetch(:reddit)
    @subreddit = args.fetch(:subreddit)
  end

  def link_ids
    (@reddit.get_listing subreddit: subreddit)["data"]["children"]
      .map{ |link| link["data"]["id"] }
  end
end

