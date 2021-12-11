# frozen_string_literal: true

class MatchPlayer < ApplicationRecord
  belongs_to :match_team
  belongs_to :player
  
  has_one :match, through: :match_team
end
