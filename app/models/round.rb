class Round < ActiveRecord::Base

  # Associations
  belongs_to :game
  belongs_to :judge, {class_name: :User}
  belongs_to :card
  has_many :responses
  accepts_nested_attributes_for :responses, update_only: true

  # Validations
  validates_numericality_of :points_awarded, {on: :update, only_integer: true, equal_to: :points}

  # Callbacks
  before_validation :update_responses_points_nil_to_zero, {on: :update}
  def update_responses_points_nil_to_zero
    responses.each{|response| response.points ||= 0}
  end

  # Instance Methods
  def current_round?
    round == game.current_round
  end
  def all_responses_received?
    responses.count == (game.num_players - 1)
  end
  def all_scores_received?
    responses.map{|response| response.points}.sum == points
  end
  def response_timeout_passed?
    false #TODO
  end
  def score_timeout_passed?
    false #TODO
  end
  def accepting_responses?
    current_round? && !all_responses_received? && !response_timeout
  end
  def accepting_scores?
    current_round? && !accepting_responses? && !all_scores_received? && !score_timeout
  end
  def player_responded?(player)
    responses.find_by(player: player)
  end
  def num_responses_missing
    game.num_players - responses.count - 1
  end
  def responses_sorted_by_response
    responses.sort_by{|response| response.response}
  end
  def responses_sorted_by_points_and_player
    responses.sort_by{|response| [-response.points, response.player.email.downcase]}
  end
  def points_awarded
    responses.map{|response| response.points}.sum
  end

  # Save response
  def save_response(params)
    response = responses.create(params)
    start_score_timer if accepting_scores?
    return response
  end
  # Save scores and move to the next round
  def save_scores(params)   
    update_attributes(params)
    game.next_round unless accepting_scores?
  end

  # Response/Save Timeouts
  def start_response_timer
    delay(run_at: game.timeout.minutes.from_now).response_timeout_callback
  end
  def start_score_timer
    delay(run_at: game.timeout.minutes.from_now).score_timeout_callback
  end
  def response_timeout_callback
    if accepting_responses?
      update_attribute(:response_timeout, true)
      if responses.count == 0
        update_attribute(:score_timeout, true)
        game.next_round
      else
        start_score_timer
      end
    end
  end
  def score_timeout_callback 
    if accepting_scores?
      update_attribute(:score_timeout, true)
      responses.each{|response| response.update_attributes(points: 1)}
      game.next_round
    end
  end

end
