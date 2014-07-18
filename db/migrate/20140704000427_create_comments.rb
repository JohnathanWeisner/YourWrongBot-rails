class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.string :comment_id
      t.text :retort
      t.string :reply_status
      t.datetime :commented_on
      t.references :subreddit, index: true

      t.timestamps
    end

    add_index :comments, :comment_id
    add_index :comments, :reply_status
    add_index :comments, :commented_on
  end
end
