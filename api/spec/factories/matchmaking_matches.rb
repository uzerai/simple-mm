# frozen_string_literal: true

FactoryBot.define do
  factory :'matchmaking/match', class: 'Matchmaking::Match' do
    match { create :match }

    initialize_with { new(match:) }

    # Model can't be persisted.
    skip_create
  end
end
