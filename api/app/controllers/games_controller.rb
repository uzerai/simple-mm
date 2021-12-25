class GamesController < ApplicationController

	def index
		@results = Game.all.as_json
		render_response
	end
end
