class GameUser < ActiveRecord::Base

  # Associations
  belongs_to :game
  belongs_to :player, {class_name: :User, foreign_key: :user_id}
  has_many :responses, ->(game_user){where(player: game_user.player)}, {through: :game}

  # Validations
  validates_presence_of :game
  validates_presence_of :player
  validates_numericality_of :result, {allow_nil: true, only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2}

  def points
    responses.map{|response| response.points}.sum
  end

  def set_lose
    update_attributes(result: 0)
  end
  def set_tie
    update_attributes(result: 1)
  end
  def set_win
    update_attributes(result: 2)
  end

end
