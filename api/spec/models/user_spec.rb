# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#valid?' do
    context 'when the user is invalid' do
      let(:user) { build :user, username: nil, email: nil }

      it 'raises RecordInvalid error on save' do
        expect { user.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(user.errors).to contain_exactly \
          "Email can't be blank", "Username can't be blank"
      end
    end

    context 'when there already exists a user with the provided email' do
      let(:existing_user) { create :user }
      let(:user) { build :user, email: existing_user.email }

      it 'raises a RecordInvalid error on save' do
        expect { user.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(user.errors).to contain_exactly 'Email has already been taken'
      end
    end
  end

  describe '#jwt_token' do
    let(:user) { create :user }
    let(:decoded_token) { JWT.decode(subject, ENV.fetch('JWT_SIGN_SECRET', 'defaultsecret'), true, algorithm: 'HS256').first }

    context 'without extended expiry' do
      subject { user.jwt_token }

      it 'returns a signed, valid token' do
        expect(subject).not_to be_nil
        expect { decoded_token }.not_to raise_error
        # The token should expire within the day
        expected_expire_date = Time.now + ENV.fetch('JWT_TOKEN_EXPIRE_MINUTES', 720).to_i.minutes
        expect(decoded_token.fetch('expire')).to include(
          expected_expire_date.day.to_s,
          expected_expire_date.month.to_s,
          expected_expire_date.year.to_s
        )
      end
    end

    context 'with extended expiry' do
      subject { user.jwt_token(extended_expiry: true) }

      it 'returns a signed, valid token' do
        expect(subject).not_to be_nil
        expect { decoded_token }.not_to raise_error
        # Extended expiry makes the expire-time +1year, so check if expire contains next year, same day.
        expected_expire_date = Time.now + 1.year
        expect(decoded_token.fetch('expire')).to include(
          expected_expire_date.day.to_s,
          expected_expire_date.month.to_s,
          expected_expire_date.year.to_s
        )
      end
    end
  end
end
