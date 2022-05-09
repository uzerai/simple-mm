# frozen_string_literal: true

FactoryBot.define do
  factory :match_player do
    association :match_team
    association :player

    start_rating { player.rating }

    trait :with_end_rating do
      end_rating { Faker::Number.between(from: 1200, to: 2000)}
    end
  end
end
