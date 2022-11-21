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

  def ready_check(match_id, user_id)
    logger.info "MatchmakingConnection#ready_check | Readying up player #{user_id} for match #{match_id}"
    # TODO: Should receive data in the format of player_id and match_id.
    # then readies the player in the context of the match, and returns currently ready players,
    # and currently awaiting players.
    begin
      match = Match.find(match_id)
      player = match.players.find_by(user_id: user_id)
      Matchmaking::Match.new(match).ready_up(player)
    rescue
      logger.warn "Could not ready_check for user: #{user_id} in match: #{match_id}"
    end
  end
end
