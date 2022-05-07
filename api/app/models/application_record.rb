# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Let's define the logger here so we don't have to everywhere else.
  @logger = Rails.logger

  private

  attr_reader :logger
end
