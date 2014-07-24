class Subreddit < ActiveRecord::Base
  has_many :comments

  def todays_comments
    self.comments.todays_comments
  end

  def todays_errors
    self.todays_comments.todays_errors
  end
end 