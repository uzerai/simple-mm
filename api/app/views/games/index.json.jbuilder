# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.partial! 'games/game', collection: @games, as: :game
end
