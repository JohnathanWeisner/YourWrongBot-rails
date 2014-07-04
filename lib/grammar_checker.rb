require 'gingerice'

class GrammarChecker

  def initialize
    @responses = ["Excuse me, but I think you made a mistake there", "Ehem", "...", "FTFY"]
  end

  def contains?(words, comment)
    !!(/#{words.join("|")}/.match(comment[:body]))
  end

  def different_your?(one, two)
    match_one = /youre|your|you're|you are/.match(one.downcase)
    match_two = /youre|your|you're|you are/.match(two.downcase)
    if match_one.respond_to?(:[]) && match_two.respond_to?(:[])
      match_one[0] != match_two[0]
    else
      false
    end
  end

  def your_error?(comment)
    comment[:grammar_fails].each do |error|
      if contains?(["your","you're","you are"], body: error["text"]) && 
        different_your?(error["text"],error["correct"])

        return true
      end
    end
    false
  end

  def snootify(comment)
    start = Time.now
    puts "snootify start"
    results = Gingerice::Parser.new.parse(comment[:body])
    comment[:grammar_fails] = results["corrections"]
    comment[:corrected] = "#{@responses.sample} \n\n>#{results['result']}"
    puts "snootify finished #{Time.now - start}"
    comment
  end

end