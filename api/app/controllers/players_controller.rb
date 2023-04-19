# frozen_string_literal: true

class PlayersController < BaseController
  def index
    @players = Player.all.order(rating: :desc)
    render_response
  end

  def show
    @player = Player.eager_load(:matches).find_by(id: params[:id])

    if @player.present?
      render_response
    else
      add_error(404, 'Player not found.')
      render_response(:not_found)
    end
  end
end
