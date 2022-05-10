# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#valid?' do
    context 'when the game is invalid' do
      let(:game) { build :game, name: nil }

      it 'raises a RecordInvalid error on save' do
        expect { game.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(game.errors).to contain_exactly "Name can't be blank"
      end
    end
  end
end
