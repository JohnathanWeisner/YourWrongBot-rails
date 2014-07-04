class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :comment_id
      t.datetime :commented_on
      t.references :subreddit, index: true
    end
    add_index :comments, :comment_id
    add_index :comments, :commented_on
  end
end
