require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    context 'when the user is valid' do
      let(:user) { FactoryBot.build(:user) }
  
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
end
