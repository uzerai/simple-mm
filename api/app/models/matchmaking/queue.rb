# frozen_string_literal: true

module Matchmaking
  class Queue
    include Matchmaking::Client
    include Matchmaking::Player

    attr_accessor :league

    def initialize(league:)
      @league = league
    end

    # Add the player to a set of other players who are currently in queue for the given league.
    def add(player)
      logger.info "Matchmaking::Queue#add | Adding player #{player.id} to queue #{league.id}"
      client.zadd queue_key, player.rating, player_value(player)
    end

    # Remove the player from the set of other players currently in queue for the given league.
    def remove(player)
      logger.info "Matchmaking::Queue#remove | Removing player #{player.id} from queue #{league.id}"
      client.zrem queue_key, player_value(player)
    end

    # Get amount of players currently in queue for a given game.
    def count(no_cache: false)
      return client.zcard queue_key if no_cache

      count = client.get count_key

      unless count.present?
        count = client.zcard queue_key
        # Set the value only if the key isn't present
        # due to minor safety with race conditions across clusters if needed.
        client.setnx count_key, count
        # Set expire so the value will always be at _least_ this recent.
        client.expire count_key, 1
      end

      count.to_i
    end

    # Lists the players in queue for a league, and their scores.
    def players_in_queue
      client.zrange queue_key, 0, -1, with_scores: true
    end

    # Returns a random player, and their rating from the queue whilst
    # removing them from the queue itself. Can return nil if the
    # reservation fails.
    def reserve_player
      player_value = (client.zrandmember queue_key, 1)&.first

      client.zrem queue_key, player_value if player_value.present?

      player_value
    end

    private

    def count_key
      "CNT:#{league.id}"
    end

    def queue_key
      "@G#{league.game_id}@L#{league.id}"
    end
  end
end
