# frozen_string_literal: true

class GamesController < BaseController
  # Essentially makes the routes in only:[] public
  skip_before_action :ensure_authorized, only: [:index]

  def index
    @games = Game.all
    render_response
  end

  def show
    @game = Game.eager_load(:leagues).find_by!(slug: params[:game_slug])

    if @game.present?
      render_response
    else
      add_error(404, 'Game not found.')
      render_response(:not_found)
    end
  end
end
