# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.partial! 'leagues/league', league: @league, include: %i[game match_type] if @league.present?
end
