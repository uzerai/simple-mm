# frozen_string_literal: true

module Matchmaking
  class FindMatchWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'matchmaking', retry: false

    @logger = Rails.logger

    attr_accessor :target_match, :player, :league, :logger

    def perform(league_id, player_id)
      @league = League.find(league_id)
      @player = Player.find(player_id)

      # Add the player to queue
      MatchmakingQueue.add_to_queue(league, player)

      # TODO: Check if there are any matches in a given elo range
      # If there are, check for the existence of matchmaking workers for those matches
      # queue up matchmaking workers if there are none
      # otherwise, create a new match in the correct elo range
      return if existing_matches.any?

      logger.info 'FindMatchWorker#perform | No matches exist for league, creating one.'
      create_new_match
    end

    private

    # Checks for existing matches for the league; if there are any.
    def existing_matches
      @existing_matches ||= Match.where(league:, state: [Match::STATE_QUEUED])
    end

    # Checks for a current match where the player is already in.
    def current_match
      @current_match ||= Match.where(league:, state: [Match::STATE_PREPARING, Match::STATE_QUEUED])
                              .joins(match_teams: :match_players)
                              .merge(MatchPlayer.where(player:))
    end

    def create_new_match
      @target_match = Match.create!(match_type: league.match_type, league:, spawn_matchmaking_worker: true)
      logger.info("OrganizeMatchWorker#create_new_match | Created match #{target_match.id}")

      match_teams = target_match.create_match_teams!
    end
  end
end
