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
  self.implicit_order_column = "created_at"
  
  belongs_to :match

  has_many :match_players, dependent: :destroy
  has_many :players, through: :match_players

  enum :outcome, [:draw, :win, :loss]

  def calculate_rating!
    ratings = match_players.pluck(:start_rating)
    
    update!(avg_rating: (ratings.reduce(:+).to_f / ratings.size)) if ratings.any?
  end
end
