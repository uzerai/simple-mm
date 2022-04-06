# frozen_string_literal: true
# == Schema Information
#
# Table name: leagues
#
#  id            :uuid             not null, primary key
#  cover_image   :string
#  desc          :text
#  name          :string           not null
#  official      :boolean          default(FALSE)
#  public        :boolean          default(FALSE)
#  rated         :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  game_id       :uuid             not null
#  match_type_id :uuid
#
# Indexes
#
#  index_leagues_on_game_id        (game_id)
#  index_leagues_on_match_type_id  (match_type_id)
#
 
class League < ApplicationRecord
  # Since we use UUID for id, sort by created_at for correct ordering.
  self.implicit_order_column = "created_at"

  mount_uploader :cover_image, CoverImageUploader

  rails_admin do
    list do
      exclude_fields :cover_image
    end
  end
  
  has_many :players
  has_many :matches

  belongs_to :match_type, required: false
  belongs_to :game

  validates :name, :game,  presence: true

  def player_count
    players.select(:user_id).map(&:user_id).uniq.count
  end
end
