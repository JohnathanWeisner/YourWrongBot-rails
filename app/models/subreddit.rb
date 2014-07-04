class Subreddit < ActiveRecord::Base
  has_many :comments
end 