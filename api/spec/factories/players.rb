FactoryBot.define do
  factory :player do
    association :user
    association :game
    association :league

    username { Faker::Internet.username }
    rating { Faker::Number.between(from: 1000, to: 2400) }
  end
end
