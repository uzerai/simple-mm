# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
	has_many :game_types
	has_many :players
end
