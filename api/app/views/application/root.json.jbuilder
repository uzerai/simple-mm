# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.version @version
end
