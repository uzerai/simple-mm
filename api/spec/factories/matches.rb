# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    league { association :league }
    # Matches will always have a league, and to keep 
    # things simple, the same match_type as that league.
    match_type { league.match_type } 

    spawn_matchmaking_worker { false }

    trait :with_worker do
      spawn_matchmaking_worker { true }
    end

    trait :with_full_teams do
      after :create do |match|
        create_list :match_team, match.match_type.team_count, 
          :full_team, :calculated_rating, match:
      end
    end
  end
end
