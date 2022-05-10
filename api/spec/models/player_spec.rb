# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#valid?' do
    context 'when the player is invalid' do
      let(:player) { build :player, username: nil, game: nil, user: nil }

      it 'raises RecordInvalid error on save' do
        expect { player.save! }.to raise_error ActiveRecord::RecordInvalid
        expect(player.errors).to contain_exactly \
          "Game can't be blank", "Username can't be blank", "User can't be blank",
          'Game must exist', 'User must exist'
      end
    end
  end
end
