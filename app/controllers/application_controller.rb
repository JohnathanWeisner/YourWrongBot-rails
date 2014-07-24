class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :todays_graph_data,:current_subreddits

  def current_subreddits
    @subreddits = Subreddit.where(name: @todays_graph_data.keys)
  end

  def todays_graph_data
    @todays_graph_data = Comment.todays_graph_data
  end

end
