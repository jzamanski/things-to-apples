FactoryGirl.define do
  factory :game do
    num_players 3
    num_rounds { |u| u.num_players }
  end
end
