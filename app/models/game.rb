class Game < ActiveRecord::Base
  
  # Associations
  belongs_to :creator, {class_name: :User, inverse_of: :created_games}
  has_many :game_players, {class_name: :GameUser}
  has_many :players, {through: :game_players}
  
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

  #
  # Instance methods
  #
  
  # Add a player to the game
  def add_player(player)
    # Confirm the game is not full
    unless self.players.count < self.num_players
      game.errors.add(:base, 'Game is full')
      return false
    end
    # Add player
    self.game_players.create(player: player, player_number: self.game_players.count+1)
    if self.players.count == num_players
      self.update_attributes(round: 1)
    end
  end

  # Private methods
  private
    
    # Set default values
    def set_defaults
      self.num_rounds ||= 3
      self.num_players ||= 3
      self.active = true
      self.round = 0
    end

end
