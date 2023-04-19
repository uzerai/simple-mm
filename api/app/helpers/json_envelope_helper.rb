# frozen_string_literal: true

module JsonEnvelopeHelper
  def json_envelope(json, status, errors)
    json.status status
    
    json.data do
      yield if block_given?
    end

    json.errors errors do |error|
      json.partial! "errors/error", error:
    end
  end
end
