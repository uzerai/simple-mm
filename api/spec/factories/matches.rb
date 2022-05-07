FactoryBot.define do
  factory :match do
    association :match_type
    association :league

    spawn_matchmaking_worker { false }

    trait :with_worker do
      spawn_matchmaking_worker { true }
    end

    trait :with_full_teams do
      after :create do |match|
        match.create_match_teams!
        match.match_teams.each do |match_team|
          create_list :match_player, match.match_type.team_size, match_team: match_team
        end
      end 
    end
  end
end
