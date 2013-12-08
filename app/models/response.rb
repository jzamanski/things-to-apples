class Response < ActiveRecord::Base

  # Associations
  belongs_to :round
  belongs_to :player, {class_name: :User}
  has_one :game, {through: :round}

  # Validations
  validates_presence_of :response
  validate :player_playing_game, {on: :create}
  validate :player_not_judge, {on: :create}
  validate :round_accepting_responses, {on: :create}
  validates_uniqueness_of :player, {scope: :round, message: 'has already responsed'}
  
  # Validation Methods
  def player_playing_game
    errors.add(:player, 'is not playing this game') unless game.players.include?(player)
  end
  def player_not_judge
    errors.add(:player, 'is the judge') if game.current_round.judge == player
  end
  def round_accepting_responses
    errors.add(:round, 'is not accepting responses') unless game.current_round.responding?
  end

end
