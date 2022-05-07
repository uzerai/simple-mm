# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.username }
    password { Faker::Internet.password }

    avatar { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'support', 'fixtures', 'assets', 'user_avatar.jpg'), 'image/jpg') }

    # Skips the confirmation step of the devise creation stages.
    before(:create, &:skip_confirmation!)

    trait :unconfirmed do
      confirmed_email { nil }
    end

    trait :without_avatar do
      avatar { nil }
    end
  end
end
