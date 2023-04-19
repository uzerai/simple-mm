# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.partial! 'matches/match', match: @match, include: %i[league game match_teams]
end
