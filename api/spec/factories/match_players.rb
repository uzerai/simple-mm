# frozen_string_literal: true

FactoryBot.define do
  factory :match_player do
    match_team { association :match_team }
    player { create :player, game: match_team.match.game, league: match_team.match.league }

    start_rating { player.rating }

    trait :with_end_rating do
      end_rating { Faker::Number.between(from: 1200, to: 2000) }
    end
  end
end
