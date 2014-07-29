class CreateCommentsByDay < ActiveRecord::Migration
  def change
    create_table :comments_by_days do |t|
      t.datetime :day
      t.integer :total
      t.string :mistake
      t.references :subreddit, index: true
    end
    add_index :comments_by_days, :day
    add_index :comments_by_days, :total
    add_index :comments_by_days, :mistake
  end
end
