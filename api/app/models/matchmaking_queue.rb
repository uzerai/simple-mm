class MatchmakingQueue
	# Static methods for matchmaking

	class << self
		# For debugging purposes, remove at some point to avoid 
		# redis pollution of malformed keys.
		def client
			@@matchmaking_client ||= Redis.new(url: ENV.fetch('MATCHMAKING_QUEUE_URL') { 'redis://localhost:6379/2' })
		end

		def disconnect_user(user)
			
		end

		# Add the player to a set of other players who are currently in queue for the given league.
		def add_to_queue(league, player)
			client.zadd(queue_key(league), player.rating, player_value(player))
		end

		# Remove the player from the set of other players currently in queue for the given league.
		def remove_from_queue(league, player)
			client.zrem(queue_key(league), player_value(player))
		end

		# Get amount of players currently in queue for a given game.
		def queue_count(league)
			count = client.get count_key(league)

			unless count.present?
				count = client.zcard queue_key(league)
				# Set the value only if the key isn't present
				# due to minor safety with race conditions across clusters if needed.
				client.setnx count_key(league), count
				# Set expire so the value will always be at _least_ this recent.
				client.expire count_key(league), 1
			end

			count
		end

		# Lists the players in queue for a league, and their scores.
		def players_in_queue(league)
			client.zrange(queue_key(league), 0, -1, with_scores: true)
		end

		def reserve_player_from_queue(league)
			client.zpopmax queue_key(league), 1
		end

		def count_key(league)
			"CNT:#{league.id}"
		end

		def queue_key(league)
		"@G#{league.game_id}@L#{league.id}"
		end

		def player_value(player)
			"#{player.id}|#{player.username}"
		end
	end
end