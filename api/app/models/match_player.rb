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
#  match_team_id :bigint
#  player_id     :bigint
#
# Indexes
#
#  index_match_players_on_match_team_id  (match_team_id)
#  index_match_players_on_player_id      (player_id)
#
class MatchPlayer < ApplicationRecord
  belongs_to :match_team
  belongs_to :player
  
  has_one :match, through: :match_team

  def calculate_end_rating
    enemy_team = match.match_teams.where.not(id: match_team.id).first
    delta_rating = (((enemy_team.avg_rating - start_rating).abs / match_team.avg_rating.to_f) * 50).floor
    if match_team.outcome == "W"
      end_rating = start_rating + delta_rating
    else
      end_rating = start_rating - delta_rating
    end

    update!(end_rating: end_rating)
    player.update(rating: end_rating)

    return end_rating
  end
end
