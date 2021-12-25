# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id         :uuid             not null, primary key
#  rating     :integer
#  username   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#  index_players_on_user_id  (user_id)
#
class Player < ApplicationRecord
  
  def matches
    match_teams
  end

  private

  belongs_to :user
  belongs_to :game

  has_many :match_players
  has_many :match_teams, through: :match_players

end
