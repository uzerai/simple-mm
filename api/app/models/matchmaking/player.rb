# frozen_string_literal: true

module Matchmaking
  module Player
    def player_value(player)
      "#{player.id}|#{player.username}"
    end
  end
end
