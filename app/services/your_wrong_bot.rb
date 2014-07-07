require 'snoo'
require 'reddit_parser'
require 'grammar_checker'

class YourWrongBot

  def self.run
    init
    all_comments = @parser.all_comments_flattened
    @subreddits.each do |subreddit|
      subreddit_id = Subreddit.where(name: subreddit).first_or_create!.id
      all_comments.map do |comment|
        process_comment comment
      end
    end
  end

  # private

  def self.init
    @client = Snoo::Client.new
    @client.log_in ENV['REDDIT_USERNAME'], ENV['REDDIT_PASSWORD']
    @subreddits = ENV['SUBREDDITS']
    @parser = RedditParser.new
    @grammar_checker = GrammarChecker.new
  end

  def self.process_comment comment
    if @grammar_checker.contains?(["your","you're","you are","youre"], comment)
      snootified_comment = @grammar_checker.snootify(comment)
      if @grammar_checker.your_error?(snootified_comment)
        reply_status = "soon"
      else
        reply_status = "never"
      end
      store_comment snootified_comment
    end
  end

  def self.store_comment comment
    db_comment = Comment.where(comment_id: comment[:id]).first_or_initialize({ 
      commented_on: comment[:comment_on],
      reply_status: reply_status,
      retort: comment[:corrected],
      subreddit_id: subreddit_id,
      body: comment[:body]
    })

    db_comment.save if db_comment.new_record?
  end

  def self.reply_to_next_comment
    comment = Comment.where(reply_comment: "soon").first
    response = @client.comment comment.retort, comment.comment_id
    puts response
  end

end