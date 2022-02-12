# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do |id|
  username = "user_#{id + 1}"
  user = User.create!(username: username, email: "#{username}@email.com", password: "password", confirmed_at: Time.now)
end

physical_games = []
electronic_games = [
  ["League of Legends", ["2|5"] ],
  ["Counter Strike: Global Offensive", ["2|16", "2|5"] ],
  ["Dota 2", ["2|5"] ],
  ["Player Unknown's Battlegrounds", ["64|1"] ],
  ["Valorant", ["2|5"] ],
  ["Apex Legends", ["33|3"]],
  ["Halo Infinite", ["2|16"]],
  ["Tom Clancy's Rainbow Six Siege", ["2|5"]],
  ["Minecraft", ["2|5"] ],
  ["World of Warcraft",["2|5"] ],
  ["Pokémon Emerald",["2|1"] ],
  ["Teamfight Tactics",["8|1", "4|2"] ],
  ["Overwatch",["2|6"] ],
  ["Crossfire",["2|5"] ],
  ["Starcraft 2",["2|1"] ],
  ["Warcraft III: Reforged",["2|1"] ],
  ["Age Of Empires IV",["2|1"] ],
  ["osu!",["2|1"] ],
  ["Black Desert Online",["2|3"] ],
  ["Legends of Runeterra",["2|1"] ],
]

# all_games = physical_games + electronic_games

electronic_games.each do |game_array|
  game = Game.create!(name: game_array.first)
  match_types = game_array.last

  # match_type_1v1 = MatchType.create!(name: "1v1 - SOLO", team_size: 1, team_count: 2, game: game)
  # match_type_5v5 = MatchType.create!(name: "5v5 - TEAM", team_size: 5, team_count: 2, game: game)
  # match_type_1v1v1 = MatchType.create!(name: "1v1v1 - FFA", team_size: 1, team_count: 3, game: game)

  match_types.each do |match_type_string|
    team_count = match_type_string.split("|").first.to_i
    team_size = match_type_string.split("|").last.to_i

    match_type_name = begin 
      result = ""

      unless team_count > 2
        result << "#{team_size}"
        (team_count - 1).times { result << "v#{team_size}" } 
      else
        result << "#{team_size}-man"
      end

      result << " - "
      

      if team_size == 1
        result << "SOLO"
      elsif team_size > 1
        result << "TEAM"
      else
        result << "FFA"
      end
      
      result
    end

    MatchType.create!(name: match_type_name, team_size: team_size, team_count: team_count, game: game)
  end

  official_match_type = MatchType.where(game: game).sample

  league_unrated = League.create!(name: "PUBLIC LEAGUE", match_type: official_match_type, game: game, public: true, rated: false)
  league_rated = League.create!(name: "RATED PUBLIC LEAGUE", game: game, match_type: official_match_type, public: true)

  User.find_each.with_index do |user, index|
    user_player_unrated = Player.create!(username: "Player_#{index + 1} UNRATED", rating: rand(1000..2000), user: user, game: game, league: league_unrated)
    user_player_rated = Player.create!(username: "Player_#{index + 1} RATED", rating: rand(1000..2000), user: user, game: game, league: league_rated)
  end

  2.times do |number|
    # Half the games rated, half the game not.
    league = (number > 49) ? league_unrated : league_rated
  
    match_type =  league.match_type
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
end



