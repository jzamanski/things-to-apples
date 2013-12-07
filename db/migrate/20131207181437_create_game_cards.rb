class CreateGameCards < ActiveRecord::Migration
  def change
    create_table :game_cards do |t|
      t.references :game, index: true
      t.integer :round
      t.references :card, index: true

      t.timestamps
    end
  end
end
