# frozen_string_literal: true
# == Schema Information
#
# Table name: matches
#
#  id            :uuid             not null, primary key
#  started_at    :date
#  ended_at      :date
#  state         :string
#  match_type_id :uuid             not null
#  league_id     :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_matches_on_league_id      (league_id)
#  index_matches_on_match_type_id  (match_type_id)
#

class Match < ApplicationRecord
  include AASM
  # Since we use UUID for id, sort by created_at for correct ordering.
  self.implicit_order_column = "created_at"
  
  has_many :match_teams, dependent: :destroy
  has_many :match_players, through: :match_teams
  has_many :players, through: :match_players

  belongs_to :match_type, required: true
  belongs_to :league, required: true

  has_one :game, through: :league

  after_create :spawn_matchmaking_worker!, if: :spawn_matchmaking_worker?

  # Such that we can conditionally create workers
  attr_writer :spawn_matchmaking_worker

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

    after_all_transitions :broadcast_status

    event :prepare do
      transitions from: :queued, to: :preparing, guard: :full_teams?
    end

    event :ready do
      transitions from: :preparing, to: :readying, guard: :full_teams?
    end

    event :live do
      transitions from: :readying, to: :live
      after do
        self.update(started_at: Time.now)
      end
    end

    event :complete do
      transitions from: :live, to: :completed
      after do
        self.update(ended_at: Time.now)
      end
    end

    event :cancel do
      transitions from: [:readying, :live], to: :cancelled
      after do
        self.update(ended_at: Time.now)
      end
    end

    event :abort, before: :log_game_aborted do
      transitions to: :aborted
      after do
        self.update(ended_at: Time.now)
      end
    end
  end

  # Returns a boolean representation of whether each team for the match is full.
  def full_teams?
    # Initially true, and is turned false by any team _not_ being full.
    match_teams.reduce(true) do |bool, team|
      bool && team.full?
    end
  end

  # Broadcasts the upcoming state of the match to the matchmaking channel.
  def broadcast_status
    logger.info "Match#broadcast_status | Broadcasting updated status of match: #{self.id} | #{aasm.from_state} -> #{aasm.to_state}"

    # For all players in the match, broadcast to the user which owns the player.
    players.each do |player|
      MatchmakingChannel.broadcast_to(player.user, { status: aasm.to_state })
    end
  end

  # Creates the match teams for a match, according to the 
  # gametype of the match itself.
  def create_match_teams!
    match_teams = []

    match_type.team_count.times { 
      team = MatchTeam.create(match: self, avg_rating: 0)
      match_teams.push(team)
    }

    logger.info("Match#create_match_teams | Created match teams: [#{match_teams.map(&:id).join(", ")}]")

    return match_teams
  end

  # Returns the average rating of the match.
  def rating
    ratings = match_players.pluck(:start_rating)
    
    return ratings.reduce(:+).to_f / ratings.size
  end

  # Starts a Matchmaking::OrganizeMatchWorker to create the match.
  def spawn_matchmaking_worker!
    Matchmaking::OrganizeMatchWorker.perform_async self.id
  end

  private

  # Optional paramater to be provided at create time, and if set to 
  # true, will invoke the spawn_matchmaking_worker method above.
  def spawn_matchmaking_worker?
    !!@spawn_matchmaking_worker
  end
end
