# frozen_string_literal: true

module Matchmaking
  module Client
    def self.client
      Matchmaking::Client.new.client
    end

    def client
      @client ||= Redis.new(url: ENV.fetch('MATCHMAKING_QUEUE_URL', 'redis://localhost:6379/2'))
    end

    private

    # Enables the use of the rails logger in all models which
    # include the client; this will be all models related to matchmaking.
    def logger
      Rails.logger
    end
  end
end
