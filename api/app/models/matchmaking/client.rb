# frozen_string_literal: true

##
# The Matchmaking Module is an abstraction module for interfacing with a Redis client
# which contains the information of current matchmaking information, such as active Queues
# active Matches and currently queued Players.
#
# The classes within this module are most likely used only in the context of 2-way communication
# in the MatchmakingChannel.
#
module Matchmaking
  class Client
    def self.client
      new.client
    end

    def client
      @client ||= Redis.new(url: ENV.fetch('MATCHMAKING_QUEUE_URL', 'redis://localhost:6379/2'))
    end

    protected

    # Enables the use of the rails logger in all models which
    # include the client; this will be all models related to matchmaking.
    def logger
      Rails.logger
    end
  end
end
