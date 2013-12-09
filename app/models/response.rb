class Response < ActiveRecord::Base

  # Associations
  belongs_to :round
  belongs_to :player, {class_name: :User}
  has_one :game, {through: :round}

  # Validations
  validates_presence_of :response
  validates_numericality_of :points, {only_integer: true, greater_than_or_equal_to: 0}
  validates_uniqueness_of :player, {scope: :round, message: 'has already responded'}
  
  validate :player_playing_game, {on: :create}
  def player_playing_game
    errors.add(:player, 'is not playing this game') unless game.players.include?(player)
  end
  protected :player_playing_game

  validate :player_not_judge, {on: :create}
  def player_not_judge
    errors.add(:player, 'is the judge') if game.round.judge == player
  end
  protected :player_not_judge

  validate :round_accepting_responses, {on: :create}
  def round_accepting_responses
    errors.add(:round, 'is not accepting responses') unless game.round.accepting_responses?
  end
  protected :round_accepting_responses

  # Callbacks
  before_validation :set_defaults, {on: :create}
  def set_defaults
    self.points = 0
  end
  protected :set_defaults

end
