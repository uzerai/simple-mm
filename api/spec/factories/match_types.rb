# frozen_string_literal: true

FactoryBot.define do
  factory :match_type do
    game { association :game }

    team_count { 2 }
    team_size { 1 }
    name { '1v1' }

    trait :five_man do
      team_count { 2 }
      team_size { 5 }
      name { '5v5' }
    end

    trait :ffa do
      team_count { 3 }
      team_size { 1 }
      name { '1v1v1' }
    end
  end
end
