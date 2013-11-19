class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :num_players
      t.integer :num_rounds
      
      t.timestamps
    end
  end
end
