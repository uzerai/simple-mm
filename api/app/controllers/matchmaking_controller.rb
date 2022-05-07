# frozen_string_literal: true

class MatchmakingController < BaseController

  attr_accessor :player, :league

  # Should return a match_id which the user will listen to for progress on queue.
  def queue
    @player = Player.find(queue_params[:player_id])
    @league = League.find(queue_params[:league_id])

    logger.info "MatchmakingController#queue | Creating match worker for match"
    Matchmaking::FindMatchWorker.perform_async(league.id, player.id)

    @results = { queue: "#{player.id}:#{league.id}" }

    render_response
  end

  private

  def queue_params
    params.required(:matchmaking).permit([:league_id, :player_id])
  end
end
