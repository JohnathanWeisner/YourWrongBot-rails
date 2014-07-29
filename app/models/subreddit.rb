class Subreddit < ActiveRecord::Base
  has_many :comments
  has_many :comments_by_days

  def todays_comments
    self.comments.todays_comments
  end

  def todays_errors
    self.todays_comments.todays_errors
  end
end 