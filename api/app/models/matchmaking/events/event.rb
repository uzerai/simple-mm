# frozen_string_literal: true

module Matchmaking
  module Events
    class Event
      TYPES = [
        'Matchmaking::Events::ReadyCheckCompletedEvent': { player_id: nil, match_id: nil }
      ]

      def initialize(event_data:)
        @raw_event_data = event_data
        super()
      end

      def self.ingest(event_data)
        # TODO: Figure out the event type, then just instantiate that type.
        case event_data?.event_type
        when "MatchMaking::Events::ReadyCheckCompletedEvent"
          Matchmaking::Events::ReadyCheckCompletedEvent.handle(event_data)
        else
          logger.warn "Matchmaking::Events::Event#ingest | No matching type"
        end
      end
    end
  end
end