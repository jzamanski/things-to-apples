class AddTimeoutsToRound < ActiveRecord::Migration
  def change
    add_column(:rounds, :response_timeout, :boolean)
    add_column(:rounds, :score_timeout, :boolean)
  end
end
