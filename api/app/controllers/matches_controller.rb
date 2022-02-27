# frozen_string_literal: true

class MatchesController < BaseController
	def show
		match = Match.find_by(id: params[:id])

		unless match.present?
			add_error(404, "Match not found.")
			render_response(:not_found)
      return
		end

    @results = {
      match: match,
      league: match.league.as_json,
      game: match.game.as_json,
      match_teams: match.match_teams.as_json(include: { match_players: { include: :player }})
    }
    render_response
	end
end
