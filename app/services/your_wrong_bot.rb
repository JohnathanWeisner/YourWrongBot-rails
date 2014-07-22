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
    @client = Snoo::Client.new(useragent: "Hello_I_Grammared_It - Grammar correcting bot")
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
      commented_on: comment[:commented_on],
      reply_status: reply_status,
      retort: comment[:corrected],
      subreddit_id: @subreddit_id,
      body: comment[:body]
    })

    db_comment.save if db_comment.new_record?
  end

  def self.reply_to_next_comment
    init
    comments = Comment.where(reply_status: "soon")
    puts "Comments to post: #{comments.count}"
    comments.each do |comment|
      if comment
        sleep(2)
        response = @client.comment(format_reply(comment.retort), "t1_#{comment.comment_id}")
        unless response['json'] && response['json'].is_a?(Hash) && response['json']["ratelimit"] && response['json']["ratelimit"] > 0
          comment.update(reply_status: 'commented')
        else
          puts response['json']["ratelimit"]
          sleep(response['json']["ratelimit"])
          self.reply_to_next_comment
        end
      end
    end
  end

  def self.beginning
    ["Sorry to bother you, but it seems you have misused, \"you're\", \"your\", or \"you are\".\n\nI went ahead and corrected the grammar for you to the best of my ability.",
     "Hi.\n\nI love helping others with their uses of the words \"you're\", \"your\", or \"you are\". I hope you don't mind me rewriting what you wrote for you.",
     "Hello there. I try to help as many people as I can with the correct use cases of the words \"you're\", \"your\", or \"you are\". You're awesome so I figured I would help you out today. Here, I fixed what you wrote for you.",
     "'Ello there, matie. I realize a lot of people rush and don't pay attention while writing comments so this isn't that big a deal. I still feel compelled to fix your \"you're\", \"your\", or \"you are\" uses for you. Please do not take offense. Here you go!",
     "*Hugs* I love you for who you are and not the grammar you just used. I love you so much so that I retyped up what was written and fixed the use cases of \"you're\", \"your\", or \"you are\". I hope I cause no offense. Here you go!",
     "Your comment is clearly constructive and I realize that typing quickly on Reddit while paying attention to grammar is not everyone's top priority, but I feel like the need to rewrite what what was written with the correct \"you're\", \"your\", or \"you are\". I hope you don't mind."].sample
  end

  def self.format_reply comment
    "#{beginning}\n\n>#{comment.gsub("\n\n","\n\n>")}\n\n Have a lovely day!"
  end

end