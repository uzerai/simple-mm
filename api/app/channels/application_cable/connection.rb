module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include Auth

    identified_by :user
 
    def connect
      unless logged_in?
        reject_unauthorized_connection
      end

      self.user = current_user
    end
 
    private

    def auth_param
      request.params[:token]
    end
  end
end