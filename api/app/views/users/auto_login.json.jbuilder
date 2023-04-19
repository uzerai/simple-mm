json_envelope(json, response.status, @errors) do
  json.token @token if @token.present?
end