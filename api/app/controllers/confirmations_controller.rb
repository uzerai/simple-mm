# frozen_string_literal: true

class ConfirmationsController < Devise::ConfirmationsController
  # Class exists almost entirely to customize devise functionality.

  private

  # Overriden to avoid an error where devise would assume the sessions-helper
  # was generated (but this project don't generate it, as it doesn't use sessions)
  def after_confirmation_path_for(resource_name, resource)
    ENV.fetch('CONFIRMATION_REDIRECT'){ "/" }
  end
end
