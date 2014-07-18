# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140704000553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: true do |t|
    t.text     "body"
    t.string   "comment_id"
    t.text     "retort"
    t.string   "reply_status"
    t.datetime "commented_on"
    t.integer  "subreddit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["comment_id"], name: "index_comments_on_comment_id", using: :btree
  add_index "comments", ["commented_on"], name: "index_comments_on_commented_on", using: :btree
  add_index "comments", ["reply_status"], name: "index_comments_on_reply_status", using: :btree
  add_index "comments", ["subreddit_id"], name: "index_comments_on_subreddit_id", using: :btree

  create_table "grammar_mistakes", force: true do |t|
    t.string  "type"
    t.string  "correction"
    t.integer "comment_id"
  end

  add_index "grammar_mistakes", ["comment_id"], name: "index_grammar_mistakes_on_comment_id", using: :btree
  add_index "grammar_mistakes", ["correction"], name: "index_grammar_mistakes_on_correction", using: :btree
  add_index "grammar_mistakes", ["type"], name: "index_grammar_mistakes_on_type", using: :btree

  create_table "subreddits", force: true do |t|
    t.string "name"
  end

  add_index "subreddits", ["name"], name: "index_subreddits_on_name", using: :btree

end
