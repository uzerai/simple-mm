# Error for instigating the job to be retried.
class Matchmaking::MatchNotFinalizedError < StandardError; end
class Matchmaking::NoPlayersError < StandardError; end

class Matchmaking::OrganizeMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'matchmaking'

  logger = Rails.logger

  attr_accessor :match

  def perform(match_id)
    @match = Match.find(match_id)

    # PSEUDO-TODO:
    # Find the match, and the league
    # recurringly (via sidekiq retries) attempt to assemble players
    # if there are enough players in queue available to play in the match
    # remove the players from queue, set the match to preparing,
    # send a matchmaking channel event to instigate ready-check
    # if players accept, create the match teams
    # if the players do not accept, return everyone to queue and try again.

    # TODO: if there are any players in the queue, check their eligibility to join the match
    raise Matchmaking::NoPlayersError unless available_players.any?

    logger.info "OrganizeMatchWorker#perform | #{match.id} | Players in queue, attempting to organize."

    # If there are enough players in queue -- create the match teams and pla
    if available_players.count >= (match.match_type.team_size * match.match_type.team_count)
      logger.info "OrganizeMatchWorker#perform | #{match.id} | Enough players for match. Filling teams."

      # For each player; keep putting them into candidate teams until teams are full
      until match.full_teams?
        reserved_queue_player = MatchmakingQueue.reserve_player_from_queue(match.league)
        if reserved_queue_player.present?
          player = Player.find_by(id: reserved_queue_player.first.split("|").first)
          create_match_player(player) unless player.nil?
        else
          logger.info "OrganizeMatchWorker#perform | #{match.id} | Failed to reserve player from queue."
        end
      end

      match.prepare!

      return true
    end

    raise Matchmaking::MatchNotFinalizedError
  end

  private

  def available_players
    MatchmakingQueue.players_in_queue(match.league)
  end

  def candidate_teams(player)
    @candidate_teams ||= match.match_teams
      .left_joins(:match_players)
      .merge(
        MatchPlayer.where
          .not(player: player)
        .or(MatchPlayer.where(player: nil))
      ).to_a
      .reject(&:full?)
  end

  def create_match_player(player)
    target_team = candidate_teams(player).sample

    logger.info("OrganizeMatchWorker#create_match_player | Creating MatchPlayer { player: #{player.id}, team: #{target_team.id} }")
    # Create the match player for the match.
    MatchPlayer.create!(match_team: target_team, player: player, start_rating: player.rating)

    # Update rating after adding a player to the team
    target_team.calculate_rating!
  end

  # def find_available_match
  #   # TODO: Only search within certain avg_ratings. 
  #   available_matches = league.matches.where(state: [Match::STATE_PREPARING, Match::STATE_QUEUED])
  #   logger.info("OrganizeMatchWorker#find_available_match | Available matches: #{available_matches.count}")

  #   # Guard clause in case there are no available matches
  #   unless available_matches.any?
  #     logger.info("OrganizeMatchWorker#find_available_match | No available matches.")
  #     return false 
  #   end

  #   @target_match = available_matches.sample
  #   logger.info("OrganizeMatchWorker#find_available_match | Joining first available match: #{target_match.id}")

  #   # TODO: Some way to avoid a match with the player already in it
  #   @candidate_teams = target_match.match_teams
  #     .left_joins(:match_players)
  #     .merge(
  #       MatchPlayer.where
  #         .not(player: player)
  #       .or(MatchPlayer.where(player: nil))
  #     ).to_a
  #     .reject(&:full?)

  #   @target_team = @candidate_teams.sample

  #   if target_team.nil?
  #     logger.info("OrganizeMatchWorker#find_available_match | No available teams in target Match.")
  #     return false
  #   end

  #   return true
  # end
end
