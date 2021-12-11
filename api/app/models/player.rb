# frozen_string_literal: true

class Player < ApplicationRecord
  def matches
    match_teams
  end

  private

  has_many :match_players
  has_many :match_teams, through: :match_players
end
