# frozen_string_literal: true

class PlayersController < BaseController
  def index
    @results = Player.all.as_json(include: :matches)
    render_response
  end

  def show
    @results = Player.find(params[:id]).as_json(include: :matches)

    unless @results.present?
      add_error(404, "Player not found.")
      render_response(:not_found)
    else
      render_response
    end
  end
end
