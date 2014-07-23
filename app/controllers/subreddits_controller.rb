class SubredditsController < ApplicationController
  def index
    @todays_graph_data = Comment.joins(:subreddit).group(:name).where( "commented_on >= ?", 
      Time.zone.now.beginning_of_day).where("reply_status != 'never'").count
    @subreddits = Subreddit.where(name: @todays_graph_data.keys)
    @todays_percentage_graph_data = Hash.new
    
    @subreddits.each do |subreddit|
      total_today = subreddit.comments.where( "commented_on >= ?", 
        Time.zone.now.beginning_of_day).count
      @todays_percentage_graph_data[subreddit.name] = (@todays_graph_data[subreddit.name] / total_today.to_f) * 100
    end
  end

  def show
    @subreddit = Subreddit.where(name: params[:subreddit])
    @comments = @subreddit.comments.where( "commented_on >= ?", 
        Time.zone.now.beginning_of_day)
  end
end
