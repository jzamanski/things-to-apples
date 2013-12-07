# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game_card, :class => 'GameCards' do
    game nil
    card nil
  end
end
