# frozen_string_literal: true

class BaseController < ActionController::API
  include Auth

  # This class contains sections of code intended to serve utility in _all_ functions of the application.

  # --- Before action section:

  # Ensures content type received is of supported types.
  before_action :ensure_content_type
  before_action :ensure_authorized

  # The basic logger in al™l controllers
  attr_accessor :logger, :user, :current_user_token, :errors, :results

  def initialize
    @logger = Rails.logger
  end
    
  # --- Private functionality shared for all controllers ---
  private

  # Validation function which is used for the 'before_action' hook 
  # to ensure the received request content-type header is of the correct type(s)
  def ensure_content_type
    unless request.headers['Content-Type'] == 'application/json'
      add_error(415, "Content-Type 'application/json' required.")
      render_response
    end
  end

  # TODO: Render using a default json serializer which reacts to raised Errors and 
  # maybe add this to its own lib/ include which appends these methods if the 
  # controller defines something like `uses_default_response_structure`
  # 
  # --- Very simple consistent response format. Works for now.
  def add_error(code = 500, message = "Error.")
    @errors ||= []
    @errors.push({
      code: code,
      message: message
    })
  end

  def add_model_errors(model)
    @errors ||= []
    return unless model.present?

    model.errors.each do |error|
      @errors.push({
        code: 422,
        message: "#{error.attribute} #{error.message}"
      })
    end
  end
  
  def render_response(status = :ok)
    render json: {
      results: @results,
      errors: @errors
    }, status: status
  end
end
  