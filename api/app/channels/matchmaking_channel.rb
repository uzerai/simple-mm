# frozen_string_literal: true

class MatchmakingChannel < ApplicationCable::Channel
  def subscribed
    stream_for user
  end

  def unsubscribed
    league = League.find(params[:room])
    player = user.players.find_by(league:)

    logger.info "MatchmakingConnection#disconnect | Disconnecting user #{user.id} from queues"
    Matchmaking::Queue.new(league:).remove(player)

    logger.info "MatchmakingConnection#disconnect | Disconnecting user #{user.id} from active match"
    Matchmaking::Player.new(player:).remove_from_matches!
  end

  def receive(data)
    # TODO: Data should probably have an event type and some stuff
  end
end
