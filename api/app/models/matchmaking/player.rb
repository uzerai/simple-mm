# frozen_string_literal: true

module Matchmaking
  module Player
    # Extracts the ID from a given Matchmaking::Client Player representation.
    def self.id(player_value)
      player_value.split('|').first
    end

    # Encodes a player representation for use with Matchmaking::Client
    def player_value(player)
      "#{player.id}|#{player.username}"
    end
  end
end
