class AddResultToGameUser < ActiveRecord::Migration
  def change
    add_column(:game_users, :result, :integer)
  end
end
