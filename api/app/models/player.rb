# frozen_string_literal: true

# == Schema Information
#
# Table name: players
#
#  id         :uuid             not null, primary key
#  rating     :integer
#  username   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :uuid             not null
#  league_id  :uuid             not null
#  user_id    :uuid
#
# Indexes
#
#  index_players_on_game_id    (game_id)
#  index_players_on_league_id  (league_id)
#  index_players_on_user_id    (user_id)
#

class Player < ApplicationRecord
  # Since we use UUID for id, sort by created_at for correct ordering.
  self.implicit_order_column = 'created_at'

  rails_admin do
    object_label_method do
      :username
    end
  end

  belongs_to :user, inverse_of: :players
  belongs_to :game, inverse_of: :players
  belongs_to :league, inverse_of: :players

  has_many :match_players
  has_many :match_teams, through: :match_players

  validates :game, :user, :username, presence: true

  def matches
    match_teams
  end
end
