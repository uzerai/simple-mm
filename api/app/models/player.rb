# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  rating     :integer
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Player < ApplicationRecord
  
  def matches
    match_teams
  end

  private

  has_many :match_players
  has_many :match_teams, through: :match_players
end
