# frozen_string_literal: true

# Errors for instigating the job to be retried.
module Matchmaking
  module Errors
    class MatchNotFinalizedError < CustomApiError; end
    class NoPlayersError < CustomApiError; end
    class PlayerNotInMatchError < CustomApiError; end
  end
end
