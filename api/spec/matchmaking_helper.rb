# frozen_string_literal: true

# Simple helper which interacts with a redis instance.
# Clears the matchmaking redis instance before each example.

RSpec.configure do |config|
  config.before(:each) { Matchmaking::Client.client.flushdb }
  config.after(:each) { Matchmaking::Client.client.quit }
end
