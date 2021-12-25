# == Schema Information
#
# Table name: match_types
#
#  id         :uuid             not null, primary key
#  name       :string           not null
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
	belongs_to :game
end
