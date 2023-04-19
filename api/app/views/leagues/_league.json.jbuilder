# frozen_string_literal: true

json.call(league, :id, :cover_image, :desc, :name, :official, :public, :rated, :created_at, :top5, :player_count)

if local_assigns[:include]&.include? :game
  json.game do
    json.partial! 'games/game', game: league.game
  end
end

if local_assigns[:include]&.include? :match_type
  json.match_type do
    json.partial! 'match_types/match_type', match_type: league.match_type
  end
end
