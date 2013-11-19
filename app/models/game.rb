class Game < ActiveRecord::Base
  has_many :game_users
  has_many :users, through: :game_users
  
  validates_numericality_of :num_players, {only_integer: true, greater_than: 0, less_than_or_equal_to: 10}
  validates_numericality_of :num_rounds, {only_integer: true, greater_than: 0, less_than_or_equal_to: 10}

end
