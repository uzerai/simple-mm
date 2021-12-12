# == Schema Information
#
# Table name: match_types
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  team_count :integer          not null
#  team_size  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MatchType < ApplicationRecord
end
