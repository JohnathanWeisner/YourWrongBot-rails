class SubredditsController < ApplicationController
  def index
    @todays_graph_data = Comment.joins(:subreddit).group(:name).where( "commented_on >= ?", 
      Time.zone.now.beginning_of_day).where("reply_status != 'never'").count
  end
end
