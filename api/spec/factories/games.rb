# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    name { Faker::Lorem.word }
    physical { false }
    cover_image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'fixtures', 'assets', 'game_cover.jpg'), 'image/jpg') }

    trait :physical do
      physical { true }
    end

    trait :with_league do
      after :create do |game|
        match_type = create :match_type, game: game
        create :league, game:, match_type:
      end
    end
  end
end
