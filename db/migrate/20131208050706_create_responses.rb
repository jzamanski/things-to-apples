class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :round
      t.references :player
      t.string :response
      t.integer :points

      t.timestamps
    end
  end
end
