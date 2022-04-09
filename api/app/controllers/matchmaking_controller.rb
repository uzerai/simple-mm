# frozen_string_literal: true

class MatchmakingController < BaseController

  attr_accessor :target_match, :target_team, :match_player, :player, :league

  # Should return a match_id which the user will listen to for progress on queue.
  def queue
    @player = Player.find(queue_params[:player_id])
    @league = League.find(queue_params[:league_id])
    logger.info [player, league]

    # If there are any match in the league where the user is currently matching in;
    # return the first found match.
    if existing_matches.any?
      logger.info "MatchmakingController#queue | Found existing match for user."

      @results = existing_matches.first
      render_response
      return
    end

    create_new_match unless find_available_match

    create_match_player

    @results = target_match.as_json

    render_response
  end

  private

  def queue_params
    params.required(:matchmaking).permit([:league_id, :player_id])
  end

  def existing_matches
    @existing_matches ||= Match.where(league: league, state: [Match::STATE_PREPARING, Match::STATE_QUEUED])
      .joins(match_teams: :match_players )
      .merge(MatchPlayer.where(player: player))
  end

  def find_available_match
    # TODO: Only search within certain avg_ratings. 
    available_matches = league.matches.where(state: [Match::STATE_PREPARING, Match::STATE_QUEUED])
    logger.info("MatchmakingController#find_available_match | Available matches: #{available_matches.count}")

    # Guard clause in case there are no available matches
    unless available_matches.any?
      logger.info("MathmakingController#find_available_match | No available matches.")
      return false 
    end

    @target_match = available_matches.sample
    logger.info("MatchmakingController#find_available_match | Joining first available match: #{target_match.id}")

    # TODO: Some way to avoid a match with player already in it
    @target_team = target_match.match_teams
      .left_joins(:match_players)
      .merge(
        MatchPlayer.where
          .not(player: player)
        .or(MatchPlayer.where(player: nil))
      ).sample

    if target_team.nil?
      logger.info("MathmakingController#find_available_match | No available teams in target Match.")
      return false
    end

    return true
  end

  def create_new_match
    @target_match = Match.create!(match_type: league.match_type, league: league)
    logger.info("MatchmakingController#create_new_match | Created match #{target_match.id}")

    match_teams = target_match.create_match_teams!

    @target_team = match_teams.sample
  end

  def create_match_player
    logger.info("MatchmakingController#create_match_player | Creating MatchPlayer { player: #{player.id}, team: #{target_team.id} }")
    @match_player = MatchPlayer.create!(match_team: target_team, player: player, start_rating: player.rating)

    # Update rating after adding a player to the team
    target_team.calculate_rating!
  end
end
