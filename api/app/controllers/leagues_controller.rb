# frozen_string_literal: true

class LeaguesController < BaseController
	# Leagues which are for a game of a given :slug param.
	# Includes both the game and its leagues in the json (along with each leagues' player count).
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

	def show
		league = League.joins(:game)
			.find_by(id: params[:id])

		unless league.present?
			add_error(404, "League not found")
			render_response(:not_found)
			return
		end

		@results = {
			league: league.as_json(include: :game)     
		}
		render_response
	end
end
