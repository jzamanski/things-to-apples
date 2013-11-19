class CreateGameUsers < ActiveRecord::Migration
  def change
    create_table :game_users do |t|
      t.references :game, null: false
      t.references :user, null: false
      t.integer :player_number, null: false

      t.timestamps
    end
  end
end
