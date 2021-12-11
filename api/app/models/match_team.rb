# frozen_string_literal: true

class MatchTeam < ApplicationRecord
  SIZE = 1

  belongs_to :match
  has_many :match_players, dependent: :destroy
end
