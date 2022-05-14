# frozen_string_literal: true

# Errors for instigating the job to be retried.
module Matchmaking
  class MatchNotFinalizedError < StandardError; end
  class NoPlayersError < StandardError; end
end

module Matchmaking
  class OrganizeMatchWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'matchmaking'

    attr_accessor :match, :mm_match, :mm_queue

    def perform(match_id)
      @match = Match.find(match_id)
      @mm_match = Matchmaking::Match.new match
      @mm_queue = Matchmaking::Queue.new match.league

      # PSEUDO-TODO:
      # Find the match, and the league
      # recurringly (via sidekiq retries) attempt to assemble players
      # if there are enough players in queue available to play in the match
      # remove the players from queue, set the match to preparing,
      # send a matchmaking channel event to instigate ready-check
      # if players accept, create the match teams
      # if the players do not accept, return everyone to queue and try again.

      # TODO: if there are any players in the queue, check their eligibility to join the match
      raise Matchmaking::NoPlayersError unless available_players.any?

      logger.info "OrganizeMatchWorker#perform | #{match.id} | Players in queue, attempting to organize."

      # If there are enough players in queue -- create the match teams and pla
      if enough_players_in_queue?
        logger.info "OrganizeMatchWorker#perform | #{match.id} | Enough players for match. Filling teams."

        # For each player; keep putting them into candidate teams until teams are full
        until match.full_teams?
          reserved_queue_player = mm_queue.reserve_player

          unless reserved_queue_player.present?
            logger.info "OrganizeMatchWorker#perform | #{match.id} | Failed to reserve player from queue."
            raise Matchmaking::MatchNotFinalizedError
          end

          # No Error-guard necessary for player, since highly unlikely they won't exist.
          player = Player.find_by(id: reserved_queue_player.first.split('|').first)
          create_match_player player unless player.nil? # Silent errors ftw
        end

        match.prepare!

        return true
      end

      raise Matchmaking::MatchNotFinalizedError
    end

    private

    def enough_players_in_queue?
      available_players >= (match.match_type.team_size * match.match_type.team_count)
    end

    def available_players
      mm_queue.queue_count
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

      logger.info("OrganizeMatchWorker#create_match_player | Creating MatchPlayer { player: #{player.id}, team: #{target_team.id} }")
      # Create the match player for the match.
      MatchPlayer.create!(match_team: target_team, player:, start_rating: player.rating)

      # Update rating after adding a player to the team
      target_team.calculate_rating!
    end
  end
end
