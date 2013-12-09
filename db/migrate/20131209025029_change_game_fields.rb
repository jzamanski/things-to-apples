class ChangeGameFields < ActiveRecord::Migration
  def change
    remove_column(:games, :active, :boolean)
    add_column(:games, :current_state, :integer)
    rename_column(:games, :round, :current_round)
  end
end
