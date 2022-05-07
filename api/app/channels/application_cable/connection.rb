# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Auth

    identified_by :user

    def connect
      reject_unauthorized_connection unless logged_in?

      self.user = current_user
    end

    private

    def auth_param
      request.params[:token]
    end
  end
end
