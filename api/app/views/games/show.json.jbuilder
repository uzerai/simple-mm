# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.partial! 'games/game', game: @game, include: %i[leagues] if @game.present?
end
