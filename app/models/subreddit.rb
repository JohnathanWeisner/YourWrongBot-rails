class Subreddit < ActiveRecord::Base
  has_many :comments

  def todays_comments
    self.comments.where( "commented_on >= ?", Time.zone.now.beginning_of_day)
  end

  def todays_errors
    self.todays_comments.where("reply_status != 'never'")
  end
end 