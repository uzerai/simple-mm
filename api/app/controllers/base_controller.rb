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

  def auth_header
    request.headers['Authorization']
  end

  def encode_token(payload)
    JWT.encode(payload, ENV.fetch('JWT_SIGN_SECRET') { 'defaultsecret' })
  end

  def decoded_token
    if auth_header
      # The header should have format 'Bearer <JWT>'
      token = auth_header.split(' ')[1]

      begin
        # TODO: Remove ENV.fetch: replace with more elegant fetch of secret.
        @current_user_token = JWT.decode(token, ENV.fetch('JWT_SIGN_SECRET') { 'defaultsecret' }, true, algorithm: 'HS256')

        # Validate not-expired token
        expire_time =  Time.zone.parse(@current_user_token['expire'])
        return nil unless expire_time > Time.zone.now
      rescue JWT::DecodeError
        logger.warn("Decode Error: Could not decode token.")
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user ||= User.find_by(id: user_id)
    else 
      nil
    end
  end

  def logged_in?
    !!decoded_token
  end

  def authorized
    unless logged_in?
      add_error(:unauthorized, 'Please log in.')
      render_response(:unauthorized)
    end
  end

  # TODO: Render using a default json serializer which reacts to raised Errors and 
  # maybe add this to its own lib/ include which appends these methods if the 
  # controller defines something like `uses_default_response_structure`
  # 
  # --- Very simple consistent response format. Works for now.
  def add_error(code = 500, message = "Error.")
    @errors = [] if @errors.nil?
    @errors.push({
      code: code,
      message: message
    })
  end
  
  def render_response(status = :ok)
    render json: {
      results: @results,
      errors: @errors
    }, status: status
  end
end
  