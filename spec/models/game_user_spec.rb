require 'spec_helper'

describe GameUser do
  
  it { should validate_numericality_of(:player_number).only_integer.is_greater_than(0).is_less_than_or_equal_to(10) }

end
