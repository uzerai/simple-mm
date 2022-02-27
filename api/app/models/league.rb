# frozen_string_literal: true
# == Schema Information
#
# Table name: leagues
#
#  id            :uuid             not null, primary key
#  name          :string           not null
#  desc          :text
#  rated         :boolean          default("true")
#  public        :boolean          default("false")
#  official      :boolean          default("false")
#  game_id       :uuid             not null
#  match_type_id :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_leagues_on_game_id        (game_id)
#  index_leagues_on_match_type_id  (match_type_id)
#

class League < ApplicationRecord
  has_many :players
  has_many :matches

  belongs_to :match_type, required: false
  belongs_to :game

  validates :name, :game,  presence: true

  def player_count
    players.select(:user_id).map(&:user_id).uniq.count
  end
end
