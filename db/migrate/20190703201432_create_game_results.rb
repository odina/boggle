class CreateGameResults < ActiveRecord::Migration[5.2]
  def change
    create_table :game_results do |t|
      t.references :game, index: true

      t.text :found_words, array: true, default: []

      t.timestamps
    end
  end
end
