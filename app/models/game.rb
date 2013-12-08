class Game < ActiveRecord::Base
  
  # Associations
  belongs_to :creator, {class_name: :User, inverse_of: :created_games}
  has_many :game_players, {class_name: :GameUser}
  has_many :players, {through: :game_players}
  has_many :rounds
  has_many :responses, {through: :rounds}
  
  # Validations
  validates_presence_of :creator_id, :creator
  validates_presence_of :active
  validates_numericality_of :num_players, {only_integer: true, greater_than_or_equal_to: 3, less_than_or_equal_to: 10}
  validates_numericality_of :num_rounds, {only_integer: true, greater_than_or_equal_to: :num_players, less_than_or_equal_to: 10}
  validates_numericality_of :round, {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :num_rounds}

  # Callbacks
  before_validation :set_defaults, {on: :create}

  # Scopes
  def self.active
    where(active: true)
  end
  def self.awaiting_players
    where(active: true, round: 0)
  end
  def self.in_progress
    where(active: true).where('round > 0')
  end
  def self.complete
    where(active: false)
  end
  def self.created_by(user)
    where(creator: user)
  end

  # Instance methods - Informational
  def waiting?
    active && round == 0
  end
  def in_progress?
    active && round > 0
  end
  def complete?
    !active
  end
  def current_round
    rounds.find_by(round: round)
  end

  #
  # Instance methods - Business Logic
  #

  # Set default values
  def set_defaults
    num_rounds ||= 3
    num_players ||= 3
    active = true
    round = 0
  end
  protected :set_defaults

  # Add a player to the game
  def add_player(player)
    # Confirm the game is not full
    unless players.count < num_players
      game.errors.add(:base, 'Game is full')
      return false
    end
    # Add player
    game_players.create(player: player)
    if players.count == num_players
      start
      update_attributes(round: round + 1)
    end
  end

  # Start game
  def start
    # Select cards
    card_ids = Card.random(num_rounds)
    first_judge_index = Random.new.rand(num_players)
    num_rounds.times do |index|
      judge_index = ((first_judge_index + index) % num_players)
      rounds.create(round: (index + 1), card_id: card_ids[index], judge_id: player_ids[judge_index])
    end
  end
  protected :start

  # Advance game to the next round
  def next_round
    update_attributes(round: round + 1)
  end
  protected :next_round

end
