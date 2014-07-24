class Comment < ActiveRecord::Base
  belongs_to :subreddit
  has_many :grammar_mistakes
  scope :todays_comments, -> { where( "commented_on >= ?", Time.zone.now.beginning_of_day) }
  scope :todays_errors, -> { todays_comments.where("reply_status != 'never'") }
  scope :todays_graph_data, -> { todays_errors.joins(:subreddit).group(:name).count }
  scope :next_reply, -> { where(reply_status: "soon").first }
  def commented
    self.update(reply_status: 'commented')
  end
end 