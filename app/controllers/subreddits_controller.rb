class SubredditsController < ApplicationController

  def index
    @todays_graph_data = Comment.todays_graph_data
    @subreddits = Subreddit.where(name: @todays_graph_data.keys)
    @todays_percentage_graph_data = Hash.new
    
    @subreddits.each do |subreddit|
      total_today = subreddit.todays_comments.count
      @todays_percentage_graph_data[subreddit.name] = (@todays_graph_data[subreddit.name] / total_today.to_f) * 100
    end
  end

  def show
    @subreddit = Subreddit.find_by_name(params[:subreddit])
    @comments = @subreddit.todays_comments
  end
end

