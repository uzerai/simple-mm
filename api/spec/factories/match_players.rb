# frozen_string_literal: true

FactoryBot.define do
  factory :match_player do
    association :match_team
    association :player
  end
end
