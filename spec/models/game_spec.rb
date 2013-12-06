require 'spec_helper'

describe Game do
  
  it { should validate_numericality_of(:num_players).only_integer.is_greater_than(0).is_less_than_or_equal_to(10) }

  it { should validate_numericality_of(:num_rounds).only_integer.is_greater_than(0).is_less_than_or_equal_to(10) }

  it { should validate_numericality_of(:round).only_integer.is_greater_than_or_equal_to(0) }

end
