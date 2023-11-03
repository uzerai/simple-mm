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

  def ready_check(data)
    logger.info "MatchmakingConnection#ready_check | DATA: #{data}"
    logger.info "MatchmakingConnection#ready_check | Readying up player #{data['user_id']} for match #{data['match_id']}"
    # TODO: Should receive data in the format of player_id and match_id.
    # then readies the player in the context of the match, and returns currently ready players,
    # and currently awaiting players.
    begin
      match = Match.find(data['match_id'])
      # TODO: accomodate possibility of several players per user per league?
      player = match.league.players.find_by(user: data['user_id'])
      mm_match = Matchmaking::Match.new(match:)
      mm_match.ready_up(player)
      mm_match.broadcast_status
    rescue StandardError
      logger.warn "Could not ready_check for user: #{data['user_id']} in match: #{data['match_id']}"
    end
  end
end
