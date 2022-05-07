# frozen_string_literal: true

class MatchmakingConnection < ApplicationCable::Connection
  def connect
    # Force requirement of room param
    unless logged_in? || !params[:room]
      reject_unauthorized_connection
    end

    # Ensure the user is part of the league before allowing connection.
    unless current_user.leagues.pluck(:id).contains(params[:room])
      reject_unauthorized_connection
    end

    self.user = current_user
  end

  # def disconnect
  #   MatchmakingQueue.
  # end
end