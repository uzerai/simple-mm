# frozen_string_literal: true

class MatchmakingController < BaseController
  attr_accessor :player, :league

  ## 
  # Returns a match_id which the user will listen to for progress on queue.
  # This queue_id is a key String representing the 
  def queue
    @player = Player.find(queue_params[:player_id])
    @league = League.find(queue_params[:league_id])

    throw 

    logger.info 'MatchmakingController#queue | Creating match worker for match'
    Matchmaking::FindMatchWorker.perform_async(league.id, player.id)

    @queue_id = "#{player.id}:#{league.id}"

    render_response
  end

  private

  def queue_params
    params.required(:matchmaking).permit(%i[league_id player_id])
  end
end
