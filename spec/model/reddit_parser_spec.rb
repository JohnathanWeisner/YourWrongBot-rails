require 'spec_helper'
require 'reddit_parser'

describe RedditParser do
  describe '.link_ids' do
    it 'should return an array of link ids for posts in a given subreddit' do
      parser = RedditParser.new
      parser.subreddit = "gaming"
      parser.instance_variable_set( :@reddit, Reddit.new )

      result = parser.link_ids
      expect(result).to eq ["295wjz", "2958vx", "295jdq"]
    end
  end
end

# Prefix instance methods with a '#'
# describe User, '#name' do
#   it 'returns the concatenated first and last name' do
#     # setup
#     user = build(:user, first_name: 'Josh', last_name: 'Steiner')

#     # excercise and verify
#     expect(user.name).to eq 'Josh Steiner'
#   end
# end