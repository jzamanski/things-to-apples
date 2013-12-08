class RemoveGameFieldsAndCards < ActiveRecord::Migration
  def change
    remove_column :games, :judge_player_number, :integer
    remove_column :game_users, :player_number, :integer
    drop_table :game_cards do |t|
      t.references :game, index: true
      t.integer :round
      t.references :card, index: true

      t.timestamps
    end
  end
end
