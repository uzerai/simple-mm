# frozen_string_literal: true

class LeaguesController < BaseController
  # Essentially makes the routes in only:[] public
  skip_before_action :ensure_authorized, only: [:game_leagues]

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
