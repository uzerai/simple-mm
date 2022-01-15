# frozen_string_literal: true

class GamesController < BaseController

	def index
		@results = Game.all.as_json(methods: :player_count)
		render_response
	end

	def show
		@results = Game.find_by(id: params[:id])
		
		unless @results.present?
			add_error(404, "Game not found.")
			render_response(:not_found)
		else
			render_response
		end
	end

	def game_leagues
		game = Game.find_by(slug: params[:game_slug])

		unless game.present?
			add_error(404, "Game not found.")
			render_response(:not_found)
			return
		end

		@results = game.as_json(include: :leagues)
		render_response
	end
end
