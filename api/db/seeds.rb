# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

game = Game.create!(name: "GAMENAME")

match_type_1v1 = MatchType.create!(name: "1v1 - SOLO", team_size: 1, team_count: 2, game: game)
match_type_5v5 = MatchType.create!(name: "5v5 - TEAM", team_size: 5, team_count: 2, game: game)
match_type_1v1v1 = MatchType.create!(name: "1v1v1 - FFA", team_size: 1, team_count: 3, game: game)

league_unrated = League.create!(name: "PUBLIC LEAGUE", game: game, public: true, rated: false, official: true)
league_rated = League.create!(name: "RATED PUBLIC LEAGUE", game: game, match_type: match_type_5v5, public: true, official: true)

20.times do |id|
  username = "user_#{id + 1}"
  user = User.create!(username: username, email: "#{username}@email.com", password: "password", confirmed_at: Time.now)
  user_player_unrated = Player.create!(username: "Player_#{id + 1} UNRATED", rating: rand(1000..2000), user: user, game: game, league: league_unrated)
  user_player_rated = Player.create!(username: "Player_#{id + 1} RATED", rating: rand(1000..2000), user: user, game: game, league: league_rated)
end

100.times do |number|
  # Half the games rated, half the game not.
  league = (number > 49) ? league_unrated : league_rated

  match_type =  league.match_type || match_type_1v1v1
  game_match = Match.create!(started_at: Time.zone.now, ended_at: Time.zone.now + 1.hour, state: Match::STATE_COMPLETED, match_type: match_type, league: league)

  # Create match teams without any players
  match_teams = game_match.create_match_teams!

  # For each match team
  match_teams.each do |match_team|
    # Insert team_size amount of players
    game_match.match_type.team_size.times do 
      # Pick a random player who isn't in the game already
      player = game_match.league.players
        .where.not(id: game_match.reload.players.pluck(:id))
        .order(Arel.sql('RANDOM()'))
        .first

      match_player = MatchPlayer.create!(player: player, start_rating: player.rating, match_team: match_team)
    end

    # This should really be done every time before save.
    match_team.calculate_rating!
  end

  # Simulate match win/loss
  winner = match_teams.shuffle.first
  winner.update(outcome: "W")
  losers = match_teams - [winner]
  MatchTeam.where(id: losers).update_all(outcome: "L")

  match_teams.each do |team|
    team.match_players.each(&:calculate_end_rating)
  end
end