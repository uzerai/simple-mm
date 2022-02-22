class EventsChannel < ApplicationCable::Channel
  def subscribed
    stream_for user
  end
end
