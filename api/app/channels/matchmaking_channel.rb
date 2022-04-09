# frozen_string_literal: true

class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    # TODO: Room name is equal to match_id -- change to better?
    match = Match.find(params[:room])

    stream_for match
  end
end
