class GamesController < ApplicationController

	def index
		@results = Game.all.as_json
		render_response
	end

	def show
		@results = Game.find_by(id: params[:id])
		
		unless @results.present?
			add_error(:not_found, "Game not found.")
		end

		render_response
	end
end
