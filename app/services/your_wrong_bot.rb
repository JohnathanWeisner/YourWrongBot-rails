require 'snoo'
require 'json'
require 'reddit_parser'
require 'grammar_checker'

class YourWrongBot

  def self.run
    init
    @subreddits.each do |subreddit|
      @parser.subreddit = subreddit
      all_comments = @parser.all_comments_flattened
      @subreddit_id = Subreddit.where(name: subreddit).first_or_create!.id
      comment_ids = all_comments.map{|comment| comment[:id] }
      all_ready_processed_ids = Comment.where("comment_id in (?)", comment_ids).pluck(:comment_id)

      all_comments.each do |comment|
        unless all_ready_processed_ids.include? comment[:id]
          process_comment comment
        end
      end
    end
  end

  # private

  def self.init
    @client = Snoo::Client.new(useragent: "YourWrongBot - Grammar correcting bot")
    @client.log_in ENV['REDDIT_USERNAME'], ENV['REDDIT_PASSWORD']
    @subreddits = ENV['SUBREDDITS'].split(",")
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
      store_comment snootified_comment, reply_status
    end
  end

  def self.store_comment comment, reply_status
    db_comment = Comment.where(comment_id: comment[:id]).first_or_initialize({ 
      commented_on: comment[:comment_on],
      reply_status: reply_status,
      retort: comment[:corrected],
      subreddit_id: @subreddit_id,
      body: comment[:body]
    })

    db_comment.save if db_comment.new_record?
  end

  def self.reply_to_next_comment
    init
    comment = Comment.where(reply_status: "soon").first
    if comment
      sleep(2)
      response = @client.comment(format_reply(comment.retort), "t1_#{comment.comment_id}")
      comment.update(reply_status: 'commented')
      puts JSON.pretty_generate response['json']
    end
  end

  def self.format_reply comment
    "*Ehem.*\n\nI do believe **you're** mistaken.>#{comment.gsub("\n\n","\n\n>")}\n\n**I am a bot.^Please message me I'm mistaken.**"
  end

end