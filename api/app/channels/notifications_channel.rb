class NotificationsChannel < ApplicationCable::Channel

  logger = Rails.logger

  def subscribed
    stream_for user
    
    logger.info("User: #{user.username} subscribed to channel.")
  end
end
