class Comment < ActiveRecord::Base
  belongs_to :subreddit
  has_many :grammar_mistakes

  scope :next_reply, -> { where(reply_status: "soon").first }
  scope :commented, -> { update(reply_status: 'commented') }
end 