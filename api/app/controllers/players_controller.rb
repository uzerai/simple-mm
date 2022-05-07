# frozen_string_literal: true

class PlayersController < BaseController
  def index
    @results = Player.all.order(rating: :desc).as_json
    render_response
  end

  def show
    @results = Player.find(params[:id]).as_json(include: :matches)

    if @results.present?
      render_response
    else
      add_error(404, 'Player not found.')
      render_response(:not_found)
    end
  end
end
