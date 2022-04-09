# frozen_string_literal: true

class MatchmakingConnection < ApplicationCable::Connection
  def connect
    unless logged_in?
      reject_unauthorized_connection
    end

    unless current_user.matches.pluck(:id).contains(params[:room])
      reject_unauthorized_connection
    end

    self.user = current_user
  end
end