# frozen_string_literal: true

class BaseController < ActionController::Base
  # This class contains sections of code intended to serve utility in _all_ functions of the application.

  # We're skipping forgery protection as all requests will either have a JWT token which is 
  # authenticated before_action or re-freshed on 
  skip_forgery_protection

  # --- Before action section:

  # Ensures content type received is of supported types.
  before_action :ensure_content_type
  before_action :authorized

  # The basic logger in all controllers
  attr_reader :logger, :user

  def initialize
    logger = Rails.logger
  end
    
  # --- Private functionality shared for all controllers ---
  private

  # Validation function which is used for the 'before_action' hook 
  # to ensure the received request content-type header is of the correct type(s)
  def ensure_content_type
    render json: {
      results: "Error",
      errors: [
        {
          code: 415,
          message: "Content-Type 'application/json' required."
        }
      ]
    }, status: 415 unless request.headers['Content-Type'] == 'application/json'
  end

  def auth_header
    request.headers['Authorization']
  end

  def encode_token(payload)
    JWT.encode(payload, ENV.fetch('JWT_SIGN_SECRET'))
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]

      begin
        # TODO: Remove ENV.fetch: replace with more elegant fetch of secret.
        JWT.decode(token, ENV.fetch('JWT_SIGN_SECRET'), true, algorithm: 'HS256')
      rescue JWT::DecodeError
        logger.warn("Decode Error: Could not decode token.")
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      user ||= User.find_by(id: user_id)
    else 
      nil
    end
  end

  def logged_in?
    !!decoded_token
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
  