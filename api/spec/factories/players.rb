# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    association :user
    game { association :game }
    league { association :league, game: }

    username { Faker::Internet.unique.username }
    rating { Faker::Number.between(from: 1000, to: 2400) }
  end
end
