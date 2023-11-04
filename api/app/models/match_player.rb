# frozen_string_literal: true

# == Schema Information
#
# Table name: match_players
#
#  id            :uuid             not null, primary key
#  end_rating    :integer
#  start_rating  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  match_team_id :uuid
#  player_id     :uuid
#
# Indexes
#
#  index_match_players_on_match_team_id  (match_team_id)
#  index_match_players_on_player_id      (player_id)
#
class MatchPlayer < ApplicationRecord
  # Since we use UUID for id, sort by created_at for correct ordering.
  self.implicit_order_column = 'created_at'

  belongs_to :match_team
  belongs_to :player

  has_one :match, through: :match_team
  has_one :user, through: :player

  after_validation :set_start_rating
  after_save :calculate_team_rating

  # attribute :start_rating, :integer, default: -> { player.rating }

  def calculate_end_rating!
    # Can't calculate end rating if game hasn't ended.
    return nil unless match&.completed?

    enemy_teams = match.match_teams.where.not(id: match_team.id)

    # If a match_player had no enemy teams, gain no elo.
    return start_rating unless enemy_teams.count.positive?

    enemy_teams_rating_avg = enemy_teams.pluck(:avg_rating).map(&:to_f).sum / enemy_teams.count

    delta_rating = (((enemy_teams_rating_avg - start_rating).abs / match_team.avg_rating.to_f) * 50).floor

    case match_team.outcome&.to_sym
    when :win
      end_rating = start_rating + delta_rating
    when :loss
      end_rating = start_rating - delta_rating
    else
      return start_rating
    end

    update!(end_rating:)
    player.update(rating: end_rating)

    end_rating
  end

  private

  def set_start_rating
    self.start_rating = player.rating
  end

  # For use on-save, so that we force the match_team to always have
  # correct representation of the team's rating. Might not be necessary later,
  # when the queue manager ensures the rating of players added to the team.
  def calculate_team_rating
    match_team.calculate_rating!
  end
end
