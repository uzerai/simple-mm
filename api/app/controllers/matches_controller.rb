# frozen_string_literal: true

class MatchesController < BaseController
  def show
    @match = Match.eager_load(:match_type, :game, :league).find_by(id: params[:id])

    unless @match.present?
      add_error(404, 'Match not found.')
      render_response(:not_found)
      return
    end

    render_response
  end
end
