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
#  game_id       :integer          not null
#  match_type_id :uuid
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_leagues_on_game_id        (game_id)
#  index_leagues_on_match_type_id  (match_type_id)
#  index_leagues_on_slug           (slug) UNIQUE
#

class League < ApplicationRecord
  include HasSlug

  has_many :players
  has_many :matches

  belongs_to :match_type, required: false
  belongs_to :game

  validates :name, :game,  presence: true

  private

  def sluggable
		name
	end
end
