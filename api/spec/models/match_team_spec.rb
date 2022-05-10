# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchTeam, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#calculate_rating!' do
    let(:match_team) { create :match_team }

    subject { match_team.calculate_rating! }

    context 'with no players in the team' do
      it 'should return nil' do
        expect(subject).to be_nil
      end

      it 'should not make any rating changes' do
        expect { subject }.not_to change(match_team, :avg_rating)
      end
    end

    context 'with a full team' do
      let(:match_team) { create :match_team, :full_team }

      it 'should return the average rating' do
        expect(subject).to be_kind_of(Integer)
      end

      it 'should update the avg_rating field' do
        expect { subject }.to change(match_team, :avg_rating)
      end
    end
  end
end
