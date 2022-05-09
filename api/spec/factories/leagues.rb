# frozen_string_literal: true

FactoryBot.define do
  factory :league do
    match_type { association :match_type }
    game { match_type.game }

    desc { Faker::Lorem.paragraph }
    name { Faker::Esport.unique.league }
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
