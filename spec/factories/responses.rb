# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :response, :class => 'Responses' do
    phrase "MyString"
    points 1
  end
end
