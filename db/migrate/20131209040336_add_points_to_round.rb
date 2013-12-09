class AddPointsToRound < ActiveRecord::Migration
  def change
    add_column(:rounds, :points, :integer)
  end
end
