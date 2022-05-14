# frozen_string_literal: true

module Matchmaking
  class Match
    include Matchmaking::Client
    include Matchmaking::Player

    attr_accessor :match

    def initialize(match:)
      @match = match
    end

    def add(player)
      logger.info "Matchmaking::Match#add | Adding player #{player.id} to match #{match.id}"
      client.sadd match_key, player_value(player)
    end

    def remove(player)
      logger.info "Matchmaking::Match#remove | Removing player #{player.id} from match #{match.id}"
      client.srem match_key, player_value(player)
    end

    def player_count
      client.scard match_key
    end

    def full?
      player_count >= (match.match_type.team_size * match.match_type.team_count)
    end

    private

    def match_key
      "@L#{match.league.id}@M#{match.id}"
    end

    def league
      match.league
    end
  end
end
