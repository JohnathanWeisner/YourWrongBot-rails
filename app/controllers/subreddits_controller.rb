class SubredditsController < ApplicationController
  def index
    @todays_graph_data = Comment.joins(:subreddit).group(:name).where( "commented_on >= ?", 
      Time.zone.now.beginning_of_day).where("reply_status != 'never'").count
    subreddits = Subreddit.where(name: @todays_graph_data.keys)

    subreddits.each do |subreddit|
      total_today = subreddit.comments.where( "commented_on >= ?", 
        Time.zone.now.beginning_of_day).count
      @todays_graph_data[subreddit.name] = (@todays_graph_data[subreddit.name] / total_today) * 100
    end
  end
end
