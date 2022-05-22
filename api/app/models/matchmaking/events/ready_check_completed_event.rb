# frozen_string_literal: true

module Matchmaking
  module Events
    class ReadyCheckCompletedEvent < Matchmaking::Events::Event
      def self.handle(match_id:, player_id:)
        match = ::Match.find(match_id)
        player = ::Player.find(player_id)

        Matchmaking::Match.new(match:).ready_up(player)
      end
    end
  end
end