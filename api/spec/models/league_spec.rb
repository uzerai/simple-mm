# frozen_string_literal: true

require 'rails_helper'

RSpec.describe League, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#valid?' do
    context 'when the league is invalid' do
      let(:league) { build :league, name: nil }

      subject { league.save! }

      it 'raises a RecordInvalid error on save' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
        expect(league.errors).to contain_exactly "Name can't be blank"
      end
    end
  end
end
