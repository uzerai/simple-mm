# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchPlayer, type: :model do
  describe '#calculate_end_rating!' do
    # Override match to test with other match states.
    let(:match) { create :match, :with_full_teams, state: :preparing }
    let(:match_player) { match.match_players.sample }

    subject { match_player.calculate_end_rating! }

    context 'when the match has not completed' do
      it 'should return nothing and change nothing on associated player' do
        expect(subject).to be_nil
        expect { subject }.not_to change(match_player.player, :rating)
      end
    end

    context 'when the match has completed' do
      let(:match) { create :match, :with_full_teams, state: :completed }

      it 'returns the calculated rating as an integer' do
        expect(subject).to be_kind_of(Integer)
      end

      it 'sets the rating on the match_player' do
        expect{ subject }.to change(match_player, :end_rating)
      end

      it 'updates the overall rating for the user' do
        expect{ subject }.to change(match_player.player, :rating)
      end
    end
  end
end
