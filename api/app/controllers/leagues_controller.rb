# frozen_string_literal: true

class LeaguesController < BaseController
  def game_leagues
		game = Game.find_by(slug: params[:game_slug])

		unless game.present?
			add_error(404, "Game not found.")
			render_response(:not_found)
			return
		end

		@results = { 
      game: game.as_json,
      leagues: League.where(game: game).as_json(methods: :player_count)
    }
		render_response
	end
end
