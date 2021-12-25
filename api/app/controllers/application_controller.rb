# frozen_string_literal: true

class ApplicationController < BaseController
  
  # Root override to stop the stupid rails image; 
  # now just echoes server version in a JSON response.
  def root
    render json: {
      version: Rails.configuration.version
    }
  end
end
