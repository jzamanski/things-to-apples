FactoryGirl.define do
  factory :game do
    num_players 3
    num_rounds { |u| u.num_players }
    round 0
  end
end
