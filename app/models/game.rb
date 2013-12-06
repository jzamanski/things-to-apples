class Game < ActiveRecord::Base
  
  # Associations
  belongs_to :creator, {class_name: :User, inverse_of: :game}
  has_many :game_users
  has_many :users, through: :game_users
  
  # Validations
  validates_presence_of :creator_id, :creator
  validates_presence_of :state
  validates_numericality_of :state, {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3}
  validates_presence_of :num_players
  validates_numericality_of :num_players, {only_integer: true, greater_than: 0, less_than_or_equal_to: 10}
  validates_presence_of :num_rounds
  validates_numericality_of :num_rounds, {only_integer: true, greater_than: 0, less_than_or_equal_to: 10}
  validates_presence_of :round
  validates_numericality_of :round, {only_integer: true, greater_than_or_equal_to: 0}

  # Callbacks
  before_validation :set_defaults, {on: :create}

  # Constants
  STATE_NAMES = ['Awaiting Players','In Progress','Complete']

  # Scopes
  def self.waiting
    where(state: 0)
  end
  def self.active
    where(state: 1)
  end
  def self.complete
    where(state: 2)
  end
  def self.created_by(user)
    where(creator: user)
  end

  def state_name
    STATE_NAMES[self.state]
  end

  # Private methods
  private
    
    # Set default values
    def set_defaults
      self.state = 0
      self.num_rounds = 4
      self.num_players = 4
      self.round = 0
    end

end
