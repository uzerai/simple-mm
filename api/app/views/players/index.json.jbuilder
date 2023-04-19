json_envelope(json, response.status, @errors) do
  json.partial! "players/player", collection: @players, as: :player
end