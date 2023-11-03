# frozen_string_literal: true

module Matchmaking
  class OrganizeMatchWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'matchmaking', backtrace: 4

    attr_accessor :match, :mm_match, :mm_queue

    def perform(match_id)
      return unless ApplicationVariable.get('matchmaking_enabled') == 'true'

      @match = ::Match.find(match_id)

      return unless match.present? && match.queued?

      @mm_match = Matchmaking::Match.new(match:)
      @mm_queue = Matchmaking::Queue.new(league: match.league)

      # TODO: if there are any players in the queue, check their eligibility to join the match
      raise Matchmaking::Errors::NoPlayersError, 'No available players currently -- retrying later' unless available_player_count.positive?

      logger.info "OrganizeMatchWorker#perform | #{match.id} | Players in queue, attempting to organize."

      raise Matchmaking::Errors::MatchNotFinalizedError, 'Match could not be finalized -- retrying later' unless enough_players_in_queue?

      logger.info "OrganizeMatchWorker#perform | #{match.id} | Enough players for match. Filling teams."

      match.prepare!
      # For each player; keep putting them into candidate teams until teams are full
      until mm_match.full?
        reserved_queue_player = mm_queue.reserve_player

        unless reserved_queue_player.present?
          logger.info "OrganizeMatchWorker#perform | #{match.id} | Failed to reserve player from queue."
          raise Matchmaking::Errors::MatchNotFinalizedError, 'Failed to reserve a player from queue -- retrying later'
        end

        # No Error-guard necessary for player, since highly unlikely they won't exist.
        player = ::Player.select(:id, :username)
                         .find(Matchmaking::Player.details(reserved_queue_player)[:id])

        mm_match.add player
      end

      ReadyCheckWorker.perform_async(match.id) if mm_match.full?
    end

    private

    def enough_players_in_queue?
      available_player_count >= (match.match_type.team_size * match.match_type.team_count)
    end

    def available_player_count
      mm_queue.count
    end

    def candidate_teams(player)
      @candidate_teams ||= match.match_teams
                                .left_joins(:match_players)
                                .merge(
                                  MatchPlayer.where
                                    .not(player:)
                                  .or(MatchPlayer.where(player: nil))
                                ).to_a
                                .reject(&:full?)
    end

    def create_match_player(player)
      target_team = candidate_teams(player).sample

      logger.info "OrganizeMatchWorker#create_match_player | Creating MatchPlayer { player: #{player.id}, team: #{target_team.id} }"
      # Create the match player for the match.
      MatchPlayer.create!(match_team: target_team, player:, start_rating: player.rating)

      # Update rating after adding a player to the team
      target_team.calculate_rating!
    end
  end
end
