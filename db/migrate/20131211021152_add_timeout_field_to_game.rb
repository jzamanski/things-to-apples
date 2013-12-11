class AddTimeoutFieldToGame < ActiveRecord::Migration
  def change
    add_column(:games, :timeout, :integer)
  end
end
