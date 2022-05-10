# frozen_string_literal: true

# == Schema Information
#
# Table name: match_teams
#
#  id         :uuid             not null, primary key
#  outcome    :integer
#  avg_rating :integer          not null
#  match_id   :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_match_teams_on_match_id  (match_id)
#

class MatchTeam < ApplicationRecord
  # Since we use UUID for id, sort by created_at for correct ordering.
  self.implicit_order_column = 'created_at'

  belongs_to :match, required: true

  has_one :match_type, through: :match
  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players

  enum :outcome, %i[draw win loss]

  def calculate_rating!
    return unless match_players.any?

    ratings = match_players.pluck(:start_rating)

    update!(avg_rating: (ratings.reduce(:+).to_f / ratings.size).floor.to_i)

    avg_rating
  end

  def full?
    match_players.count == match_type.team_size
  end
end
