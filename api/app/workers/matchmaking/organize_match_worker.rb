class Matchmaking::OrganizeMatchWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'matchmaking'

  logger = Rails.logger

  attr_accessor :target_match, :target_team, :match_player, :player

  def perform(player_id)
    logger.info("Matchmaking::OrganizeMatchWorker#perform | Finding match for player: #{player_id}")
    player = Player.find(player_id)
    
    create_new_match unless find_available_match

    create_match_player
  end

  private

  def find_available_match
    # TODO: Only search within certain avg_ratings.
    available_matches = Match.where(state: [Match::STATE_PREPARING, Match::STATE_QUEUED])
    logger.info("Matchmaking::OrganizeMatchWorker#find_available_match | Available matches: #{available_matches.count}")

    # Guard clause in case there are no available matches
    unless available_matches.any?
      logger.info("Mathmaking::OrganizeMatchWorker#find_available_match | No available matches.")
      return false 
    end

    target_match = available_matches.sample
    logger.info("Matchmaking::OrganizeMatchWorker#find_available_match | Joining first available match: #{target_match.id}")

    # TODO: Some way to avoid a match with player already in it
    target_team = MatchTeam.left_joins(:match_players)
      .where("match_teams.match_id = #{target_match.id}")
      .group('match_teams.id')
      .having("COUNT(match_players.id) < #{MatchTeam::SIZE}")
      .sample

    unless target_team.present?
      logger.info("Mathmaking::OrganizeMatchWorker#find_available_match | No available teams in target Match.")
      return false
    end

    return true
  end

  def create_new_match
    target_match = Match.create()
    logger.info("Matchmaking::OrganizeMatchWorker#create_new_match | Created match #{target_match.id}")

    match_teams = target_match.create_match_teams!

    target_team = match_teams.sample
  end

  def create_match_player
    logger.info("Matchmaking::OrganizeMatchWorker#create_match_player | Creating MatchPlayer { player: #{player.id}, team: #{target_team.id} }")
    match_player = MatchPlayer.create(match_team: target_team, player: player)
  end
end
