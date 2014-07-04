class CreateGrammarMistakes < ActiveRecord::Migration
  def change
    create_table :grammar_mistakes do |t|
      t.string :type
      t.string :correction
      t.references :comment, index: true
    end
    add_index :grammar_mistakes, :type
    add_index :grammar_mistakes, :correction
  end
end
