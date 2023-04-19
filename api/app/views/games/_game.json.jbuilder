json.(game, :id, :cover_image, :name, :physical, :slug, :created_at, :player_count)

if local_assigns[:include]&.include? :leagues
  json.leagues do
    json.partial! "leagues/league", collection: game.leagues, as: :league
  end
end