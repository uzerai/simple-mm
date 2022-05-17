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

    def cancel!
      logger.warn "Matchmaking::Match#cancel! | Cancelling match #{match.id}"

      ::Player.select(:id, :username, :rating).where(id: ready_player_ids).find_each do |player|
        mm_queue.add player
      end

      client.del ready_check_key
      client.del match_key
    end

    # Instigates a ready check for players, and persists the match, match_teams & match_players
    # when successfully completed by all players; otherwise, removes non-accepting players
    # from the match, and raises a Matchmaking::MatchNotFinalized error.
    def ready_check!
      # TODO: The match should instigate a ready check here, and depending on
      # strategy of match type allow for pick / ban of players and or maps.
      # Sends a list of not prepared users, users who click
      # accept will send a message with their ID and will be
      # removed via WebSocket message to do so.
      match.players.each do |player|
        MatchmakingChannel.broadcast_to(player.user, { status: match.status, not_ready: player_ids, match_id: match.id })
      end
    end

    # Readies up a player in the context of a ready check for the current match.
    def ready_up(player)
      logger.info "Matchmaking::Match#ready_up | Marking player #{player.id} as ready for match #{match.id}"

      if client.sismember match_key, player_value(player)
        client.sadd ready_check_key, player_value(player)
      else
        logger.warn 'Matchmaking::Match#ready_up | Player not in match; aborting.'
        nil
      end
    end

    def players
      client.smembers match_key
    end

    def player_ids
      players.map { |player_string| Matchmaking::Player.id player_string }
    end

    def player_count
      client.scard match_key
    end

    def full?
      player_count >= (match.match_type.team_size * match.match_type.team_count)
    end

    #######################
    # Ready check related #
    #######################

    # Returns a list of player values of players who are not ready.
    def not_ready_players
      client.sdiff([match_key, ready_check_key])
    end

    # Returns a list of player values of players who are ready.
    def ready_players
      client.smembers ready_check_key
    end

    # Returns a list of player uuids of players who are ready.
    def ready_player_ids
      ready_players.map { |player_string| Matchmaking::Player.id player_string }
    end

    # Returns true if all match players have reported as ready.
    def ready?
      not_ready_players.empty?
    end

    private

    def ready_check_key
      "RDY:#{match.id}"
    end

    def match_key
      "@L#{match.league.id}@M#{match.id}"
    end

    def league
      match.league
    end

    def mm_queue
      @mm_queue ||= Matchmaking::Queue.new(league:)
    end
  end
end
