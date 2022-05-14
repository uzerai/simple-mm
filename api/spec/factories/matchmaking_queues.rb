# frozen_string_literal: true

FactoryBot.define do
  factory :'matchmaking/queue', class: 'Matchmaking::Queue' do
    league { create :league }

    initialize_with { new(league:) }

    # Model can't be persisted.
    skip_create
  end
end
