# frozen_string_literal: true

# Class exists almost entirely to customize devise functionality.
# DO NOT ALTER unless changes are made to the general authentication flow.
class ConfirmationsController < Devise::ConfirmationsController
  private

  # Overriden to avoid an error where devise would assume the sessions-helper
  # was generated (but this project don't generate it, as it doesn't use sessions)
  def after_confirmation_path_for(_resource_name, _resource)
    ENV.fetch('CONFIRMATION_REDIRECT', '/')
  end
end
