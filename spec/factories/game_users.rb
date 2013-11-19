FactoryGirl.define do
  factory :game_user do
    game {Factory.create(:game)}
    user {Factory.create(:user)}
    player_number 1
  end
end
