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
end
