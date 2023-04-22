# frozen_string_literal: true

class BaseController < ActionController::API
  include Auth

  helper JsonEnvelopeHelper

  # This class contains sections of code intended to serve utility in _all_ functions of the application.

  # --- Before action section:

  # Ensures content type received is of supported types.
  before_action :ensure_content_type
  before_action :ensure_authorized

  rescue_from CustomApiError, with: :handle_custom_api_error

  # The basic logger in all controllers
  attr_accessor :logger, :errors, :results

  def initialize
    @logger = Rails.logger

    super
  end

  private

  # Validation function which is used for the 'before_action' hook
  # to ensure the received request content-type header is of the correct type(s)
  def ensure_content_type
    raise CustomApiError.new(412, "Cannot satisfy request. Client must accept 'application/json'") if request.headers['Accept'] != 'application/json'

    return unless request.headers['Content-Type'] != 'application/json' && request.method_symbol != :get

    raise CustomApiError.new(412, "Cannot satisfy request. Expected 'Content-Type' to be 'application/json'")
  end

  def handle_custom_api_error(error)
    add_error(error.code, error.message)
    render_response(error.code)
  end

  # TODO: Render using a default json serializer which reacts to raised Errors and
  # maybe add this to its own lib/ include which appends these methods if the
  # controller defines something like `uses_default_response_structure`
  #
  # --- Very simple consistent response format. Works for now.
  def add_error(code = 500, message = 'Error.')
    (@errors ||= []).push(CustomApiError.new(code, message))
  end

  def add_model_errors(model)
    return unless model.present?

    model.errors.each do |error|
      (@errors ||= []).push(CustomApiError.new(422, "#{error.attribute} #{error.message}"))
    end
  end

  def render_response(status = :ok)
    render status:
  end
end
