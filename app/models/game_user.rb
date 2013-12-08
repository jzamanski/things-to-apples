class GameUser < ActiveRecord::Base

  # Associations
  belongs_to :game
  belongs_to :player, {class_name: :User, foreign_key: :user_id}

  # Validations
  validates_presence_of :game
  validates_presence_of :player

end
