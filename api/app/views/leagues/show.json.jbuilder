# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.partial! 'leagues/league', league: @league if @league.present?
end
