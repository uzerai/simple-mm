# frozen_string_literal: true

# Errors for instigating the job to be retried.
module Matchmaking
  class MatchNotFinalizedError < StandardError; end
  class NoPlayersError < StandardError; end
  class PlayerNotInMatchError < StandardError; end
end
