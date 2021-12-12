# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

MatchType.create(name: "1v1 - SOLO", team_size: 1, team_count: 2)
MatchType.create(name: "5v5 - TEAM", team_size: 5, team_count: 2)
MatchType.create(name: "1v1v1 - FFA", team_size: 1, team_count: 3)

10.times do |id|
  Player.create(username: "Player_#{id + 1}", rating: rand(1000..2000))
end

20.times do |_number|
  match_type = MatchType.find(1)
  match = Match.create(started_at: Time.zone.now, ended_at: Time.zone.now + 1.hour, state: Match::STATE_COMPLETED, match_type: match_type)
  team_a = MatchTeam.create(avg_rating: 0, outcome: nil, match_id: match.id)
  team_b = MatchTeam.create(avg_rating: 0, outcome: nil, match_id: match.id)

  players = Player.all.shuffle

  players.each do |player|
    match_player = MatchPlayer.create(player_id: player.id, start_rating: player.rating)

    if team_a.match_players.count <= 4
      match_player.update(match_team_id: team_a.id)
    else
      match_player.update(match_team_id: team_b.id)
    end
  end
  
  team_a.calculate_rating!
  team_b.calculate_rating!

  # Simulate match win/loss
  teams = [team_a, team_b].shuffle
  winner = teams.first
  winner.update(outcome: "W")
  loser = teams.last
  loser.update(outcome: "L")

  teams.each do |team|
    team.match_players.each(&:calculate_end_rating)
  end
end