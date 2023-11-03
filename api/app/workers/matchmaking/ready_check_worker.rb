# frozen_string_literal: true

module Matchmaking
  class ReadyCheckWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'matchmaking', retry: false, backtrace: 1

    attr_accessor :match, :mm_match, :mm_queue

    # 30s max wait time for ready checks.
    MATCHMAKING_READY_CHECK_WAIT_TIME = 30

    def perform(match_id)
      @match = ::Match.find(match_id)
      @mm_match = Matchmaking::Match.new(match:)
      @mm_queue = Matchmaking::Queue.new(league: match.league)

      # In the scenario that a user may disconnect in the moment before
      match.ready!

      # Clock-based precision timestamps
      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      time_since_last_update = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      # This loop continues to run every second, and checks if the
      # players of the match have readied up -- if they have not within
      # ::MATCHMAKING_READY_CHECK_WAIT_TIME the match will be cancelled.
      until mm_match.ready?
        time_in_loop = Process.clock_gettime(Process::CLOCK_MONOTONIC)

        # Update only once every 1s
        next unless (time_in_loop - time_since_last_update) > 1

        time_since_last_update = time_in_loop

        logger.info "ReadyCheckWorker#perform | Readying match (#{match.id})..."

        # Guard clause, if the time_in_loop ever exceeds MATCHMAKING_READY_CHECK_WAIT_TIME, the match is cancelled
        next unless (time_in_loop - started_at) > Matchmaking::ReadyCheckWorker::MATCHMAKING_READY_CHECK_WAIT_TIME

        # mm_match.cancel!
        match.cancel!
        logger.warn "ReadyCheckWorker#perform | Match (#{match.id}) cancelled due to ready-check timeout"
        # raise Matchmaking::Errors::MatchNotFinalizedError, 'Players failed to accept ready-check, cancelling match.'
        return
      end

      match.live!
    end
  end
end
