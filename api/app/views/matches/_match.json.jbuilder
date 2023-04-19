json.(match, :id, :started_at, :ended_at, :state, :created_at)

if local_assigns[:include]&.include? :match_type
  json.match_type do
    json.partial! "match_types/match_type", match_type: match.match_type
  end
end

if local_assigns[:include]&.include? :game
  json.game do
    json.partial! "games/game", game: match.game
  end
end

if local_assigns[:include]&.include? :league
  json.league do
    json.partial! "leagues/league", league: match.league
  end
end

if local_assigns[:include]&.include? :match_teams
  json.match_teams do
    json.partial! "matches/match_team", collection: match.match_teams, as: :match_team
  end
end