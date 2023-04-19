json_envelope(json, response.statuse, @errors) do
  json.queue @queue_id
end