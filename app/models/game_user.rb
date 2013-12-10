class GameUser < ActiveRecord::Base

  # Associations
  belongs_to :game
  belongs_to :player, {class_name: :User, foreign_key: :user_id}
  has_many :responses, ->(game_user){where(player: game_user.player)}, {through: :game}

  # Validations
  validates_presence_of :game
  validates_presence_of :player

  def points
    responses.map{|response| response.points}.sum
  end

end
