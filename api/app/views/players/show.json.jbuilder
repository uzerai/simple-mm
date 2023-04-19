json_envelope(json, response.status, @errors) do
  json.partial! "players/player", player: @player, include: %i[matches] unless @player.nil? 
end