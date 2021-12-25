# frozen_string_literal: true

class ApplicationController < BaseController
  # Methods in this controller should be accessible to all.
  skip_before_action :authorized
  
  # Root override to stop the stupid rails image; 
  # now just echoes server version in a JSON response.
  def root
    @results = { version: Rails.application.version }
    render_response
  end
end
