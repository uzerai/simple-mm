# frozen_string_literal: true

FactoryBot.define do
  factory :match_team do
    match { association :match }

    avg_rating { 0 }
    outcome { :loss }

    trait :full_team do
      after :create do |match_team|
        create_list :match_player, match_team.match_type.team_size, match_team:,
                                                                    player: create(:player, game: match_team.match.game, league: match_team.match.league)
      end
    end

    trait :calculated_rating do
      after :create, &:calculate_rating!
    end

    trait :win do
      outcome { :win }
    end
  end
end
