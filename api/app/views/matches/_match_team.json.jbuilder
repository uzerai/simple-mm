# frozen_string_literal: true

json.call(match_team, :id, :outcome, :avg_rating)

if local_assigns[:include]&.include? :match
  json.match do
    json.partial! 'matches/match', match: match_team.match
  end
end

if local_assigns[:include]&.include? :players
  json.players do
    json.partial! 'matches/match_player', collection: match_team.players, as: :match_player
  end
end
