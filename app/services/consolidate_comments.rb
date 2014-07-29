class ConsolidateComments

  def self.run
    Subreddit.all.each do |subreddit|
      self.build_comments_by_days(subreddit, self.comments_with_no_your_mistakes(subreddit), 'none')
      self.build_comments_by_days(subreddit, self.comments_with_your_mistakes(subreddit), 'your')
    end
    Comment.before_today.destroy_all
  end

  def self.build_comments_by_days(subreddit, comments, mistake)
    comments.each do |day, count|
      subreddit.comments_by_days.build(day: day, total: count, mistake: mistake).save
    end
  end

  def self.comments_with_no_your_mistakes(subreddit)
    Comment.group_by_day(:commented_on)
      .where(subreddit_id: subreddit.id)
      .before_today
      .no_your_mistakes
      .count
  end

  def self.comments_with_your_mistakes(subreddit)
    Comment.group_by_day(:commented_on)
      .where(subreddit_id: subreddit.id)
      .before_today
      .your_mistakes
      .count
  end
end