# frozen_string_literal: true

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
