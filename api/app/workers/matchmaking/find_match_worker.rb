# frozen_string_literal: true

module Matchmaking
  class FindMatchWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'matchmaking', retry: false

    attr_accessor :player, :league, :existing_matched

    def perform(league_id, player_id)
      return unless ApplicationVariable.get('matchmaking_enabled') == 'true'

      @league = ::League.find(league_id)
      @player = ::Player.find(player_id)

      # Guard clause for if the player is in another match already.
      if current_match.present?
        logger.warn "FindMatchWorker#perform | Player already in existing Match: #{current_match.id}"

        return
      end

      # Add the player to queue
      Matchmaking::Queue.new(league:).add player

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
      @existing_matches ||= ::Match.where(league:, state: [::Match::STATE_QUEUED])
    end

    # Checks for a current match where the player is already in.
    # TODO: support being in multiple matches so long as they are not in the same league (dunno which yet)
    def current_match
      # This section checks with the current matchmaking state for the player we've been given.
      # If they are in any match; they will be removed from the first match
      # returned by Matchmaking::Player#matches. Support multiple later.
      mm_match_keys = Matchmaking::Player.new(player:).matches
      return @current_match ||= ::Match.find(Matchmaking::Match.details(mm_match_keys.first)[:id]) if mm_match_keys.any?

      # Here we load just any last match we can find where the player is in which is not complete.
      @current_match ||= ::Match.where(league:)
                                .where.not(state: [::Match::STATE_COMPLETED, ::Match::STATE_CANCELLED, ::Match::STATE_ABORTED])
                                .joins(match_teams: :match_players)
                                .merge(::MatchPlayer.where(player:))
                                .first
    end

    def create_new_match
      target_match = ::Match.create!(match_type: league.match_type, league:, spawn_matchmaking_worker: true)
      logger.info "OrganizeMatchWorker#create_new_match | Created match #{target_match.id}"
    end
  end
end
