# frozen_string_literal: true

# == Schema Information
#
# Table name: match_teams
#
#  id         :uuid             not null, primary key
#  avg_rating :integer          not null
#  outcome    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  match_id   :bigint
#
# Indexes
#
#  index_match_teams_on_match_id  (match_id)
#
class MatchTeam < ApplicationRecord
  belongs_to :match

  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players

  def calculate_rating!
    ratings = match_players.pluck(:start_rating)
    
    update!(avg_rating: (ratings.reduce(:+).to_f / ratings.size)) if ratings.any?
  end
end
