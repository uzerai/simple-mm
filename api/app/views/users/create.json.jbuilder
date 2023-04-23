# frozen_string_literal: true

json_envelope(json, response.status, @errors) do
  json.token @token if @token.present?
  json.refresh_token @refresh_token if @refresh_token.present?
end
