json.(player, :rating, :username, :created_at)

if local_assigns[:include]&.include? :matches
  json.matches do
    json.partial! "matches/match", collection: player.matches, as: :match
  end
end