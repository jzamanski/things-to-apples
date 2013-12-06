class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Associations
  has_many :created_games, {class_name: :Game, inverse_of: :creator}
  has_many :game_users
  has_many :games, through: :game_users

end
