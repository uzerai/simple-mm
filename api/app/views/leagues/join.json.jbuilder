# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.invitation @results[:invitation]
  json.status @results[:status]
end
