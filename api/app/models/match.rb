# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  id            :bigint           not null, primary key
#  ended_at      :date
#  started_at    :date
#  state         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  match_type_id :bigint           not null
#
# Indexes
#
#  index_matches_on_match_type_id  (match_type_id)
#
class Match < ApplicationRecord
  include AASM

  TEAMS_PER_MATCH = 2

  logger = Rails.logger
  
  has_many :match_teams, dependent: :destroy
  has_many :match_players, through: :match_teams
  has_many :players, through: :match_players
  belongs_to :match_type, required: true

  aasm column: :state do
    # queued - for when the match has been created and is available to be found and the match contains no match teams
    # preparing - for when the match has at least one player and therefore an average rating
    # readying - for when the match has found sufficient players and a ready check has been broadcast
    # live - for when all players have readied and match is being played
    # completed - for when a victor was decided (through any method)
    # cancelled - for when a queued game does not have sufficient players present
    # aborted - for when a game is impacted due to technical difficulties of either clients or platform, aborted games are WARN level.
    state :queued, initial: true
    state :preparing, :readying, :live, :completed, :cancelled, :aborted
    

    event :prepare do
      transitions from: :queued, to: :preparing
    end

    event :ready do
      transitions from: :preparing, to: :readying
    end

    event :live do
      transitions from: :readying, to: :live
    end

    event :complete do
      transitions from: :live, to: :completed
    end

    event :cancel do
      transitions from: [:readying, :live], to: :cancelled
    end

    event :abort, before: :log_game_aborted do
      transitions to: :aborted
    end
  end

  def create_match_teams!
    match_teams = []

    Match::TEAMS_PER_MATCH.times { 
      team = MatchTeam.create(match: self, avg_rating: 0)
      match_teams.push(team)
    }

    logger.info("Match#create_match_teams | Created match teams: [#{match_teams.map(&:id).join(", ")}]")

    return match_teams
  end

  def rating
    ratings = match_players.pluck(:start_rating)
    
    return ratings.reduce(:+).to_f / ratings.size
  end
end
