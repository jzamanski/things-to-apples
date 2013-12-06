class ChangeGameStateToActiveFlag < ActiveRecord::Migration
  def change
    remove_column(:games, :state, :integer)
    add_column(:games, :active, :boolean)
  end
end
