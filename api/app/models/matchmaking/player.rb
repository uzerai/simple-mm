# frozen_string_literal: true

module Matchmaking
  class Player < Matchmaking::Client
    attr_accessor :player

    ##
    # Extracts the ID & username from a given Matchmaking::Client Player representation.
    #
    def self.details(player_value)
      # See https://apidock.com/ruby/String/match
      player_value.match(/^(?<id>.+)\|(?<username>.+)$/)
    end

    def initialize(player:)
      @player = player
      super()
    end

    def value
      player_value
    end

    def remove_from_matches!
      Rails.logger.info "Matchmaking::Player#remove_from_matches! | Removing #{player.id} from all matches."

      Matchmaking::Match.queued_keys.each do |match_key|
        client.srem match_key, value
      end
    end

    # TODO: Allow for scoping by league.
    def matches
      Rails.logger.info "Matchmaking::Player#matches? | Testing for existing matches for player #{player.id}"

      existing_matches = []
      Matchmaking::Match.queued_keys.each do |match_key|
        next unless client.sismember match_key, value

        existing_matches << match_key
      end

      existing_matches
    end

    private

    # Encodes a player representation for use with Matchmaking::Client.
    # Aliased as a public method #value
    def player_value
      "#{player.id}|#{player.username}"
    end
  end
end
