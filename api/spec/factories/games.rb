FactoryBot.define do
  factory :game do
    name { Faker::Esport.game }
    physical { false }
    cover_image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'fixtures', 'assets', 'game_cover.jpg'), 'image/jpg') }

    trait :physical do
      physical { true }
    end

    trait :with_league do
      after :create do |game|
        match_type = create :match_type, game: game
        create :league, game: game, match_type: match_type
        create_list :player, 2, game: game, league: league
      end
    end
  end
end
