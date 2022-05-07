# frozen_string_literal: true

module Admin
  class BaseController < ActionController::Base
    include Auth

    # This class contains sections of code intended to serve utility in _all_ functions of the application.

    # --- Before action section:
    before_action :ensure_authorized

    # The basic logger in all controllers
    attr_accessor :logger

    def initialize
      @logger = Rails.logger

      super
    end
  end
end
