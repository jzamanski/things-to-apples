class GameCard < ActiveRecord::Base
  
  # Associations
  belongs_to :game
  belongs_to :card
  
end
