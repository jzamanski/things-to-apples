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
    current_round? && !all_responses_received? && !response_timeout_passed?
  end
  def accepting_scores?
    current_round? && !accepting_responses? && !all_scores_received? && !score_timeout_passed?
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

  # Save scores and move to the next round
  def save_scores(scores)
    # Save scores
    update_attributes(scores)
    # Advance game to next round
    game.next_round unless accepting_scores?
  end

end
