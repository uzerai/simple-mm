# frozen_string_literal: true

module Matchmaking
  class OrganizeMatchWorker
    include Sidekiq::Worker
    sidekiq_options queue: 'matchmaking'

    attr_accessor :match, :mm_match, :mm_queue

    # 30s max wait time for ready checks.
    MATCHMAKING_READY_CHECK_WAIT_TIME = 30

    def perform(match_id)
      @match = ::Match.find(match_id)
      @mm_match = Matchmaking::Match.new(match:)
      @mm_queue = Matchmaking::Queue.new(league: match.league)

      # TODO: if there are any players in the queue, check their eligibility to join the match
      raise Matchmaking::NoPlayersError unless available_player_count.positive?

      logger.info "OrganizeMatchWorker#perform | #{match.id} | Players in queue, attempting to organize."

      raise Matchmaking::MatchNotFinalizedError unless enough_players_in_queue?

      logger.info "OrganizeMatchWorker#perform | #{match.id} | Enough players for match. Filling teams."

      # For each player; keep putting them into candidate teams until teams are full
      until mm_match.full?
        reserved_queue_player = mm_queue.reserve_player

        unless reserved_queue_player.present?
          logger.info "OrganizeMatchWorker#perform | #{match.id} | Failed to reserve player from queue."
          raise Matchmaking::MatchNotFinalizedError
        end

        # No Error-guard necessary for player, since highly unlikely they won't exist.
        player = ::Player.select(:id, :username)
                         .find(Matchmaking::Player.id(reserved_queue_player))

        mm_match.add player # Silent errors ftw
      end

      match.prepare!

      # In the scenario that a user may disconnect in the moment before
      mm_match.ready_check! if mm_match.full?

      # Clock-based precision timestamps
      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      time_since_last_update = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      until mm_match.ready?
        time_in_loop = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        # Update only once every 1s
        next unless (time_in_loop - time_since_last_update) > 1

        logger.info 'OrganizeMatchWorker#perform | Readying match ...'

        next unless (time_in_loop - started_at) > Matchmaking::OrganizeMatchWorker::MATCHMAKING_READY_CHECK_WAIT_TIME

        mm_match.cancel!
        match.cancel!

        raise Matchmaking::MatchNotFinalizedError
      end

      match.reload.ready!
      match.live!

      true
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
