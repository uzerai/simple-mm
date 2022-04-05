# frozen_string_literal: true
# == Schema Information
#
# Table name: match_types
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  team_count :integer          not null
#  team_size  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :uuid             not null
#
# Indexes
#
#  index_match_types_on_game_id  (game_id)
#

class MatchType < ApplicationRecord
	include HasSlug
	# Since we use UUID for id, sort by created_at for correct ordering.
	self.implicit_order_column = "created_at"

	belongs_to :game, required: true

	validates :name, :team_size, :team_count, :game,  presence: true
	validates :team_size, :team_count, numericality: { only_integer: true }

	private

	def sluggable
		"#{game.name}.#{name}"
	end
end
