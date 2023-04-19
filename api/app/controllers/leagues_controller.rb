# frozen_string_literal: true

class LeaguesController < BaseController
  # Essentially makes the routes in only:[] public
  skip_before_action :ensure_authorized, only: [:game_leagues]

  # Leagues which are for a game of a given :slug param.
  # Includes both the game and its leagues in the json (along with each leagues' player count).
  def game_leagues
    game = Game.find_by(slug: params[:game_slug])

    unless game.present?
      add_error(404, 'Game not found.')
      render_response(:not_found)
      return
    end

    @results = {
      game: game.as_json,
      leagues: League.visible_for_user(current_user)
                     .where(game:)
                     .as_json(methods: :player_count),
      user_leagues: current_user&.leagues&.as_json(methods: :player_count) || []
    }

    render_response
  end

  def show
    @league = League.eager_load(:game, :match_type, :matches)
                   .find_by(id: params[:id])

    unless @league.present?
      add_error(404, 'League not found')
      render_response(:not_found)
      return
    end

    render_response
  end

  def join
    league = League.joins(:game).find_by(id: params[:id])

    unless league.present?
      add_error(404, 'League not found')
      render_response(:not_found)
    end

    invitation = nil
    status = :accepted

    logger.info "LeaguesController#join | User:#{current_user.id} joining League:#{league.id}"
    # For now, simply use the username of the user as thee player name
    Player.create!(username: current_user.username, rating: league.starting_rating, league:, game: league.game,
                   user: current_user)

    @results = {
      invitation:,
      status:
    }
    render_response
  end
end
