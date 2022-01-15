# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  unconfirmed_email      :string
#  username               :string           not null
#  validation_dud         :string           default("virgin-validation-dud"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable

	has_many :players
	has_many :games, through: :players

	validates :username, uniqueness: true
	validates :password, length: { minimum: 8 }, confirmation: true

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
