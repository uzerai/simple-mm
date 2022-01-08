# == Schema Information
#
# Table name: users
#
#  id              :uuid             not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
	has_secure_password

	has_many :players
	has_many :games, through: :players

	def jwt_token(extended_expiry = false)
		# TODO: Add some seed-generated secret which can be randomized to invalidate all other tokens (by just checking it after decode)
		# idea is to be able to invalidate all other signed tokens, regardless of expiry.

		@signed_token ||= JWT.encode({
    	id: id, 
    	players: players.as_json(only: [:id, :game_id]),
      valid: Time.zone.now.iso8601,
      expire: (Time.zone.now + (extended_expiry ? 1.years : ENV.fetch('JWT_TOKEN_EXPIRE_MINUTES'){ 720 }.to_i.minutes)).iso8601,
      permissions: []
  	}, ENV.fetch('JWT_SIGN_SECRET') { 'defaultsecret' })
	end
end
