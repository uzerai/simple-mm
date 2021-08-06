# frozen_string_literal: true

class BaseController < ActionController::Base
    # This class contains sections of code intended to serve utility in _all_ functions of the application.

    # --- Before action section:

    # Ensures content type received is of supported types.
    before_action :ensure_content_type

      
    private
    # --- Private functionality shared for all controllers ---
  
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
  end
  