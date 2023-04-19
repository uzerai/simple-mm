# frozen_string_literal: true

class ApplicationController < BaseController
  # Methods in this controller should be accessible to all.
  skip_before_action :ensure_authorized

  # Root override to stop the stupid rails image;
  # now just echoes server version in a JSON response.
  def root
    @version = '0.0.1'
  end
end
