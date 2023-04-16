# frozen_string_literal: true

module Matchmaking
  class Match < Matchmaking::Client
    QUEUED_MATCHES_SET_KEY = 'MATCHMAKING_QUEUED'

    attr_accessor :match

    def self.queued_keys
      # This is a static method; so use a new client
      Matchmaking::Client.client.smembers QUEUED_MATCHES_SET_KEY
    end

    # Deconstructs the values from a given match_key.
    def self.details(match_key)
      match_key.match(/@L(?<league_id>.+)@M(?<id>.+)/)
    end

    def initialize(match:)
      @match = match
      super()
    end

    def add(player)
      logger.info "Matchmaking::Match#add | Adding player #{player.id} to match #{match.id}"
      client.sadd match_key, Matchmaking::Player.new(player:).value
      client.sadd QUEUED_MATCHES_SET_KEY, match_key
    end

    def remove(player)
      logger.info "Matchmaking::Match#remove | Removing player #{player.id} from match #{match.id}"
      client.srem match_key, Matchmaking::Player.new(player:).value
    end

    def cancel!
      logger.warn "Matchmaking::Match#cancel! | Cancelling match #{match.id}"

      ::Player.select(:id, :username, :rating).where(id: ready_player_ids).find_each do |player|
        mm_queue.add player
      end

      cleanup!
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
        broadcast_to_players({ status: match.state, not_ready: not_ready_players , match_id: match.id })
      end
    end

    # Readies up a player in the context of a ready check for the current match.
    def ready_up(player)
      logger.info "Matchmaking::Match#ready_up | Marking player #{player.id} as ready for match #{match.id}"
      player_wrapper = Matchmaking::Player.new(player:)
      if client.sismember match_key, player_wrapper.value
        client.sadd ready_check_key, player_wrapper.value
        
        broadcast_to_players({ status: match.state, not_ready: not_ready_players, match_id: match.id })
      else
        logger.warn 'Matchmaking::Match#ready_up | Player not in match; aborting.'
        nil
      end
    end

    def broadcast_to_players(broadcast_body)
      match.players.each do |player|
        MatchmakingChannel.broadcast_to(player.user, broadcast_body)
      end
    end

    def players
      client.smembers match_key
    end

    def player_ids
      players.map { |player_string| Matchmaking::Player.details(player_string)[:id] }
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
      ready_players.map { |player_string| Matchmaking::Player.details(player_string)[:id] }
    end

    # Returns true if all match players have reported as ready.
    def ready?
      not_ready_players.empty?
    end

    def cleanup!
      client.srem QUEUED_MATCHES_SET_KEY, match_key
      client.del ready_check_key
      client.del match_key
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
