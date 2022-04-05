# frozen_string_literal: true
# == Schema Information
#
# Table name: games
#
#  id         :uuid             not null, primary key
#  image_url  :string           default("/assets/default_game.jpg")
#  name       :string           not null
#  physical   :boolean          default(FALSE)
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_games_on_slug  (slug) UNIQUE
#

class Game < ApplicationRecord
	include HasSlug
	# Since we use UUID for id, sort by created_at for correct ordering.
	self.implicit_order_column = "created_at"

	has_many :match_types
	has_many :players
	has_many :leagues
	
	has_and_belongs_to_many :tags

	# Although called player_count, this actually counts unique users which have participated in at
	# least one league of the game.
	def player_count
		players.select(:user_id).map(&:user_id).uniq.count
	end

	private

	def sluggable
		name
	end
end
