# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do |id|
  Player.create(username: "Player_#{id + 1}", rating: 1500)
end

20.times do |_number|
  match = Match.create(started_at: Time.zone.now, ended_at: Time.zone.now + 1.hour, state: Match::STATE_COMPLETED)
  team_a = MatchTeam.create(avg_rating: 1500, outcome: "W", match_id: match.id)
  team_b = MatchTeam.create(avg_rating: 1500, outcome: "L", match_id: match.id)

  players = Player.all.shuffle

  players.each do |player|
    match_player = MatchPlayer.create(player_id: player.id)

    if team_a.match_players.count <= 4
      match_player.update(match_team_id: team_a.id)
    else
      match_player.update(match_team_id: team_b.id)
    end
  end
end