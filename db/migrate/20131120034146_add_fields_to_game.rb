class AddFieldsToGame < ActiveRecord::Migration
  def change
    add_column :games, :creator_id, :integer
    add_column :games, :state, :integer
    add_column :games, :round, :integer
  end
end
