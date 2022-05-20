# frozen_string_literal: true

module Matchmaking
  class Player < Matchmaking::Client
    # Extracts the ID from a given Matchmaking::Client Player representation.
    def self.id(player_value)
      player_value.split('|').first
    end

    attr_accessor :player

    def initialize(player:)
      @player = player
    end

    # Encodes a player representation for use with Matchmaking::Client
    def value
      "#{player.id}|#{player.username}"
    end

    def remove_from_matches!
      Rails.logger.info "Matchmaking::Player#remove_from_matches! | Removing #{player.id} from all matches."

      Matchmaking::Match.queued_keys.each do |match_key|
        Matchmaking::Client.client.srem match_key, value
      end
    end
  end
end
