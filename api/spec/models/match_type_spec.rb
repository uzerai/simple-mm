# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchType, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#valid?' do
    context 'when the match type is invalid' do
      let(:match_type) { build :match_type, name: nil, team_size: nil, team_count: nil, game: nil }

      subject { match_type.save! }

      it 'raises a RecordInvalid error on save' do
        expect { subject }.to raise_error ActiveRecord::RecordInvalid
        expect(match_type.errors).to contain_exactly  \
          "Slug can't be blank", 'Game must exist', "Name can't be blank", "Team size can't be blank",
          "Team count can't be blank", "Game can't be blank", 'Team size is not a number', 'Team count is not a number'
      end
    end
  end
end
