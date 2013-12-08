class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :game, index: true
      t.integer :round
      t.references :judge, index: true
      t.references :card, index: true

      t.timestamps
    end
  end
end
