# frozen_string_literal: true
# == Schema Information
#
# Table name: players
#
#  id         :uuid             not null, primary key
#  username   :string           not null
#  rating     :integer
#  user_id    :uuid             not null
#  game_id    :integer          not null
#  league_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_players_on_game_id    (game_id)
#  index_players_on_league_id  (league_id)
#  index_players_on_user_id    (user_id)
#

class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game
  belongs_to :league

  has_many :match_players
  has_many :match_teams, through: :match_players

  validates :game, :user, presence: true

  def matches
    match_teams
  end
end
