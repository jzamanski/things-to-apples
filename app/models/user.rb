class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, and :omniauthable
  # Removed default devise modules. :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :timeoutable, {timeout_in: 30.minutes}

  # Associations
  has_many :created_games, {class_name: :Game, inverse_of: :creator}
  has_many :game_players, {class_name: :GameUser}
  has_many :games, through: :game_players

  def wins
    game_players.select{|game_player| game_player.result == 2}.count
  end
  def ties
    game_players.select{|game_player| game_player.result == 1}.count
  end
  def loses
    game_players.select{|game_player| game_player.result == 0}.count
  end
  def result_sum
    game_players.map{|game_player| game_player.result}.sum
  end
end
