# frozen_string_literal: true

# Errors for instigating the job to be retried.
module Matchmaking
  module Errors
    class MatchNotFinalizedError < CustomApiError
      def initialize(message)
        super(500, message)
      end
    end

    class NoPlayersError < CustomApiError
      def initialize(message)
        super(500, message)
      end
    end

    class PlayerNotInMatchError < CustomApiError
      def initialize(message)
        super(500, message)
      end
    end
  end
end
