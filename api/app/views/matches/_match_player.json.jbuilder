json.(match_player, :id)

if local_assigns[:include]&.include? :player
  json.player do
    json.partial! "leagues/player", player: match_player.player
  end
end