class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # Removed default devise modules. :recoverable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable

  # Associations
  has_many :created_games, {class_name: :Game, inverse_of: :creator}
  has_many :game_users
  has_many :games, through: :game_users

  def wins
    games.select{|game| game.winner == self}.count
  end

end
