class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_for player
  end
end
