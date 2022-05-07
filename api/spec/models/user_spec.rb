require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    context 'when the user is valid' do
      let(:user) { FactoryBot.build(:user) }
  
      # I know this may introduce false negatives, in the context of validations
      # but I'd rather make sure saving valid users throws _no_ errors.
      it 'does not raise error on save' do
        expect{ user.save! }.not_to raise_error
      end
    end
  
    context 'when the user is invalid' do
      let(:user) { FactoryBot.build(:user, :invalid) }
  
      it 'raises RecordInvalid error on save' do
        expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(user.errors).to contain_exactly \
          "Email can't be blank", "Username can't be blank"
      end
    end

    context 'when there already exists a user with the provided email' do
      let(:existing_user) { FactoryBot.create(:user) }
      let(:user) { FactoryBot.build(:user, email: existing_user.email) }

      it 'raises a RecordInvalid error on save' do
        expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(user.errors).to contain_exactly "Email has already been taken"
      end
    end
  end

  describe '#jwt_token' do
    let(:user) { FactoryBot.create(:user) }
    let(:decoded_token) { JWT.decode(subject, ENV.fetch('JWT_SIGN_SECRET') { 'defaultsecret' }, true, algorithm: 'HS256').first }


    context 'without extended expiry' do
      subject { user.jwt_token }

      it 'returns a signed, valid token' do
        expect(subject).not_to be_nil
        expect { decoded_token }.not_to raise_error
        # The token should expire within the day
        expect(decoded_token.fetch('expire')).to include(Time.now.day.to_s, Time.now.month.to_s, Time.now.year.to_s)
      end
    end

    context 'with extended expiry' do
      subject { user.jwt_token(extended_expiry: true) }

      it 'returns a signed, valid token' do
        expect(subject).not_to be_nil
        expect { decoded_token }.not_to raise_error
        # Extended expiry makes the expire-time +1year, so check if expire contains next year, same day.
        expect(decoded_token.fetch('expire')).to include(Time.now.day.to_s, Time.now.month.to_s, (Time.now.year + 1).to_s)
      end
    end
  end
end
