# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#valid?' do
    context 'when the game is valid' do
      let(:game) { build :game }

      it 'does not raise error on save' do
        expect { game.save! }.not_to raise_error
      end
    end

    context 'when the game is invalid' do
      let(:game) { build :game, name: nil }

      it 'raises a RecordInvalid error on save' do
        expect { game.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(game.errors).to contain_exactly "Name can't be blank"
      end
    end
  end
end
