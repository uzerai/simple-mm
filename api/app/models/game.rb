# == Schema Information
#
# Table name: games
#
#  id         :uuid             not null, primary key
#  image_url  :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
	has_many :game_types
	has_many :players

	def player_count
		players.count
	end
end
