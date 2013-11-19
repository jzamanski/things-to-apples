FactoryGirl.define do
  factory :user do
    email 'example@example.com'
    password 'changeme'
    password_confirmation {|u| u.password}
  end
end
