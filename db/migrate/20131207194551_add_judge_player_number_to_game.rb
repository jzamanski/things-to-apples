class AddJudgePlayerNumberToGame < ActiveRecord::Migration
  def change
    add_column(:games, :judge_player_number, :integer)
  end
end
