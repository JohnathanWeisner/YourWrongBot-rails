class Comment < ActiveRecord::Base
  belongs_to :subreddit
  has_many :grammar_mistakes
end 