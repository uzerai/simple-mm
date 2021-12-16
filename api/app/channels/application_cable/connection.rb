module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :player
 
    def connect
      self.player = find_verified_player
    end
 
    private

    def find_verified_player
      if player = Player.find_by(id: cookies['player_id'])
        player
      else
        reject_unauthorized_connection
      end
    end
  end
end