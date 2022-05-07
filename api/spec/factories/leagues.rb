# frozen_string_literal: true

FactoryBot.define do
  factory :league do
    association :game
    association :match_type

    desc { Faker::Lorem.paragraph }
    name { Faker::Esport.league }
    cover_image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'fixtures', 'assets', 'league_cover.jpg'), 'image/jpg') }

    official { false }
    rated { false }

    public { true }

    trait :official do
      official { true }
    end

    trait :rated do
      rated { true }
    end

    trait :private do
      public { false }
    end
  end
end
