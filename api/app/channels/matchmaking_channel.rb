# frozen_string_literal: true

class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_for user
  end
end
