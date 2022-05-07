# frozen_string_literal: true

FactoryBot.define do
  factory :match_team do
    association :match

    trait :full_team do
      after :create do |match_team|
        create_list :match_player, match_team.match_type.team_size, match_team:
      end
    end
  end
end
