# frozen_string_literal: true

class LeaguesController < BaseController
	# Matches which have been had in a specific league.
	def matches
		league = League.joins(:game)
		.where(games: { slug: params[:game_slug] }, slug: params[:league_slug]).first

		unless league.present?
			add_error(404, "Game not found.")
			render_response(:not_found)
			return
		end

		@results = {
			league: league.as_json,
			matches: Match.where(league: league).as_json(include: :match_type)
		}
		render_response
	end

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

	# A single league for a specified :game_slug & :league_slug.
	# Needs both slugs detailed as :league_slug is only unique per game_id.
	def game_league
		league = League.joins(:game)
			.where(games: { slug: params[:game_slug] }, slug: params[:league_slug]).first

		Rails.logger.info "Something happened at least."
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
