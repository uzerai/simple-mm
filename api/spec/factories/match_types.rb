# frozen_string_literal: true

FactoryBot.define do
  factory :match_type do
    game { association :game }
    sequence(:name) { |n| "match-type-#{n}" }

    team_count { 2 }
    team_size { 1 }

    trait :five_man do
      team_count { 2 }
      team_size { 5 }
    end

    trait :ffa do
      team_count { 3 }
      team_size { 1 }
    end
  end
end
