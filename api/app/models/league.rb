# frozen_string_literal: true
# == Schema Information
#
# Table name: leagues
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  slug          :string           not null
#  rated         :boolean          default("true")
#  public        :boolean          default("false")
#  official      :boolean          default("false")
#  game_id       :integer          not null
#  match_type_id :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_leagues_on_game_id           (game_id)
#  index_leagues_on_match_type_id     (match_type_id)
#  index_leagues_on_slug_and_game_id  (slug,game_id) UNIQUE
#

class League < ApplicationRecord

  # Switching to a custom sluggable
  before_validation :set_slug

  validates :slug, uniqueness: { scope: :game_id }, presence: true

  has_many :players
  has_many :matches

  belongs_to :match_type, required: false
  belongs_to :game

  validates :name, :game,  presence: true

  def player_count
    players.select(:user_id).map(&:user_id).uniq.count
  end

  private

  def set_slug
    self.slug = self.send(:sluggable).parameterize
  end

  def sluggable
		name
	end
end
