# frozen_string_literal: true

require 'rails_helper'

RSpec.describe League, type: :model do
  describe '#valid?' do
    context 'when the league is valid' do
      let(:league) { build :league }

      it 'does not raise error on save' do
        expect { league.save! }.not_to raise_error
      end
    end

    context 'when the league is invalid' do
      let(:league) { build :league, name: nil }

      it 'raises a RecordInvalid error on save' do
        expect { league.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(league.errors).to contain_exactly "Name can't be blank"
      end
    end
  end
end
