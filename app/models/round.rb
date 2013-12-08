class Round < ActiveRecord::Base

  # Associations
  belongs_to :game
  belongs_to :judge, {class_name: :User}
  belongs_to :card
  has_many :responses

  def responding?
    responses.count < (game.num_players - 1)
  end
  def scoring?
    !responding?
  end
end
