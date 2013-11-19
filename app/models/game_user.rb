class GameUser < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates_presence_of :game
  validates_presence_of :user
  validates_numericality_of :player_number, {only_integer: true, greater_than: 0, less_than_or_equal_to: 10}

end
