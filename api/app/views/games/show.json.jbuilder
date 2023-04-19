json_envelope(json, response.status, @errors) do
  if @game.present?
    json.partial! "games/game", game: @game, include: %i[leagues]
  end
end