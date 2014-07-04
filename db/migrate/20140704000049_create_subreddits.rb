class CreateSubreddits < ActiveRecord::Migration
  def change
    create_table :subreddits do |t|
      t.string :name
    end
    add_index :subreddits, :name
  end
end
