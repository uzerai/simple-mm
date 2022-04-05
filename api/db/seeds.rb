# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# --------------------------------------------------------------- Config section
number_of_users = 10
matches_per_league = 1
physical_games = []
electronic_games = [
  ["League of Legends", ["2|5"] ],
  # ["Counter Strike: Global Offensive", ["2|16", "2|5"] ],
  # ["Dota 2", ["2|5"] ],
  # ["Player Unknown's Battlegrounds", ["64|1"] ],
  # ["Valorant", ["2|5"] ],
  # ["Apex Legends", ["33|3"]],
  # ["Halo Infinite", ["2|16"]],
  # ["Tom Clancy's Rainbow Six Siege", ["2|5"]],
  # ["Minecraft", ["2|5"] ],
  # ["World of Warcraft",["2|5"] ],
  # ["Pokémon Emerald",["2|1"] ],
  # ["Teamfight Tactics",["8|1", "4|2"] ],
  # ["Overwatch",["2|6"] ],
  # ["Crossfire",["2|5"] ],
  # ["Starcraft 2",["2|1"] ],
  # ["Warcraft III: Reforged",["2|1"] ],
  # ["Age Of Empires IV",["2|1"] ],
  # ["osu!",["2|1"] ],
  # ["Black Desert Online",["2|3"] ],
  # ["Legends of Runeterra",["2|1"] ],
]

# --------------------------------------------------------------- Config section end

number_of_users.times do |id|
  username = "user_#{id + 1}"
  user = User.create!(username: username, email: "#{username}@email.com", password: "password", confirmed_at: Time.now)
end

# unused for now, no physical games
all_games = physical_games + electronic_games

all_games.each do |game_array|
  game = Game.create!(name: game_array.first)
  match_types = game_array.last

  # Create match types from formatted string
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

  # Randomly decide on an official match type.
  official_match_type = MatchType.where(game: game).first

  league_unrated = League.create!(name: "PUBLIC LEAGUE UNRATED", match_type: official_match_type, game: game, public: true, official: true, rated: false)
  league_rated = League.create!(name: "PUBLIC LEAGUE", match_type: official_match_type, game: game, public: true, official: true)
  leagues = League.all

  User.find_each.with_index do |user, index|
    leagues.each do |league|
      user_player_unrated = Player.create!(username: "Player_#{index + 1} UNRATED", rating: rand(1000..2000), user: user, game: game, league: league_unrated)
      user_player_rated = Player.create!(username: "Player_#{index + 1} RATED", rating: rand(1000..2000), user: user, game: game, league: league_rated)
    end
  end

  leagues.each do |league|
    matches_per_league.times do |number|
      game_match = Match.create!(started_at: Time.zone.now, ended_at: Time.zone.now + 1.hour, state: Match::STATE_COMPLETED, match_type: league.match_type, league: league)
    
      # Create match teams without any players
      match_teams = game_match.create_match_teams!
    
      # For each match team
      match_teams.each do |match_team|
        # Insert team_size amount of playerse
        official_match_type.team_size.times do 
          # Pick a random player who isn't in the game already
          player = league.reload.players
            .where.not(id: game_match.reload.players.pluck(:id))
            .order(Arel.sql('RANDOM()'))
            .first
    
          match_player = MatchPlayer.create!(player: player, start_rating: player.rating, match_team: match_team)
        end
    
        # This should really be done every time before save.
        match_team.reload.calculate_rating!
      end

      # Simulate match win/loss
      winner = match_teams.shuffle.first
      winner.update(outcome: :win)
      losers = match_teams - [winner]
      MatchTeam.where(id: losers).update_all(outcome: :loss)
    
      match_teams.each do |team|
        team.reload.match_players.each(&:calculate_end_rating!)
      end
    end
  end
end



