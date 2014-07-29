class CommentsByDay < ActiveRecord::Base
  belongs_to :subreddit
  validates :day, :uniqueness => {:scope => [:mistake]}
end 