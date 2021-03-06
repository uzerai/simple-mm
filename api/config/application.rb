# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SimpleMM
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Custom logger to STDOUT. For docker purposes.
    config.log_level = :debug
    config.log_tags = %i[subdomain uuid]
    config.logger = ActiveSupport::TaggedLogging.new(Logger.new($stdout))

    # Settings in config/environments/* take precedence over those specified here.

    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # For use with the root route for the API
    config.version = '0.0.1'

    # This forces Devise not to attempt [:flash] messages.
    # See: https://github.com/heartcombo/devise/issues/4275#issuecomment-244968778
    config.navigational_formats = []

    # Setting up sidekiq
    config.active_job.queue_adapter = :sidekiq

    # Ensures schema won't lose information in 'ruby' (.rb) format
    config.active_record.schema_format = :sql
  end
end
