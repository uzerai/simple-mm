# frozen_string_literal: true

class MatchesController < BaseController
	def show
		@results = Match.find_by(id: params[:id]).as_json(include: { 
      league: { 
        include: :game
      }, 
      match_teams: { 
        include: { 
          match_players: { 
            include: :player
          }
        } 
      }
    })
		
		unless @results.present?
			add_error(404, "Game not found.")
			render_response(:not_found)
		else
			render_response
		end
	end
end
