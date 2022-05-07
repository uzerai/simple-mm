# frozen_string_literal: true

class MatchmakingConnection < ApplicationCable::Connection
  def connect
    # Force requirement of room param
    reject_unauthorized_connection unless logged_in? || !params[:room]

    # Ensure the user is part of the league before allowing connection.
    reject_unauthorized_connection unless current_user.leagues.pluck(:id).contains(params[:room])

    self.user = current_user
  end

  # def disconnect
  #   MatchmakingQueue.
  # end
end
