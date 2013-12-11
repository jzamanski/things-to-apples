class Game < ActiveRecord::Base
  
  # Associations
  belongs_to :creator, {class_name: :User, inverse_of: :created_games}
  has_many :game_players, {class_name: :GameUser}
  has_many :players, {through: :game_players}
  has_many :rounds
  has_many :responses, {through: :rounds}
  
  # Validations
  validates_presence_of :creator_id, :creator
  validates_presence_of :current_state
  validates_numericality_of :current_state, {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 3}
  validates_numericality_of :num_players, {only_integer: true, greater_than_or_equal_to: 3, less_than_or_equal_to: 100}
  validates_numericality_of :num_rounds, {only_integer: true, greater_than_or_equal_to: :num_players, less_than_or_equal_to: 100}
  validates_numericality_of :timeout, {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 60}
  validates_numericality_of :current_round, {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: :num_rounds}

  # Callbacks
  before_validation :set_defaults, {on: :create}
  def set_defaults
    self.current_state = 1
    self.current_round = 0
  end
  protected :set_defaults

  # Scopes
  def self.created_by(user)
    where(creator: user)
  end
  def self.waiting_for_players
    where(current_state: 1)
  end
  def self.in_progress
    where(current_state: 2)
  end
  def self.complete
    where(current_state: 3)  
  end
  def self.active
    where(current_state: 1..2)
  end

  # Instance Methods - Predicates
  def waiting_for_players?
    current_state == 1
  end
  def in_progress?
    current_state == 2
  end
  def complete?
    current_state == 3
  end
  def active?
    waiting_for_players? || in_progress?
  end

  # Current round object
  def round
    rounds.find_by(round: current_round)
  end

  # Game players by points
  def game_players_by_points
    game_players.sort_by{|game_player| [-game_player.points, game_player.player.email.downcase]}
  end

  # Game Winners/Losers
  def winners
    winners = game_players.select{|game_player| game_player.result == 2}.map{|game_player| game_player.player}
    winners = game_players.select{|game_player| game_player.result == 1}.map{|game_player| game_player.player} if winners.count == 0
    winners
  end
  def losers
    game_players.select{|game_player| game_player.result == 0}.map{|game_player| player}
  end

  # Players left before game starts
  def num_players_missing
    num_players - game_players.count
  end

  # Add a player to the game
  def add_player(player)
    # Confirm user isn't already playing a game
    return errors.add(:base, 'Player is already playing a game') unless player.games.active.count == 0
    # Confirm the game is not full
    return errors.add(:base, 'Game is full') unless players.count < num_players
    # Add player
    game_players.create(player: player)
    start if players.count == num_players
  end

  # Start game
  def start
    # Randomly select cards and initial judge
    card_ids = Card.sample(num_rounds)
    first_judge_index = Random.new.rand(num_players)
    # Set up rounds
    num_rounds.times do |index|
      judge_index = ((first_judge_index + index) % num_players)
      rounds.create(round: (index + 1), card_id: card_ids[index], judge_id: player_ids[judge_index], points: num_players)
    end
    # Update game state
    next_round
    update_attributes(current_state: 2)
  end
  protected :start

  # Advance game to the next round or complete the game
  def next_round
    unless current_round == num_rounds
      update_attributes(current_round: current_round + 1)
      round.start_response_timer
    else
      max_points = game_players_by_points.first.points
      if max_points == 0
        game_players.each{|game_player| game_player.set_lose}
      else
        has_winner = game_players.select{|game_player| game_player.points == max_points}.count == 1
        if has_winner
          game_players_by_points.first.set_win
        else
          game_players.select{|game_player| game_player.points == max_points}.each{|game_player| game_player.set_tie}
        end
        game_players.reject{|game_player| game_player.points == max_points}.each{|game_player| game_player.set_lose}
      end
      update_attributes(current_state: 3)
    end
  end

end
