class GameUser < ActiveRecord::Base

  # Associations
  belongs_to :game
  belongs_to :player, {class_name: :User, foreign_key: :user_id}

  # Validations
  validates_presence_of :game
  validates_presence_of :player
  validates_numericality_of :player_number, {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: ->(gu){gu.game.num_players}}

end
