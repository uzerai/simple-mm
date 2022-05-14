# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matchmaking::Match, type: :model do
  describe 'Match manipulation' do
    let(:matchmaking_match) { create :'matchmaking/match', match: }
    let(:league) { create :league }
    let(:player) { create :player, league:, game: league.game }
    let(:match) { create :match, league:, game: league.game, match_type: league.match_type }

    describe '#add' do
      subject { matchmaking_match.add player }

      it 'adds a player to the queued representation of a match' do
        expect { subject }.to change { matchmaking_match.player_count }.from(0).to(1)
      end
    end

    describe '#remove' do
      subject { matchmaking_match.remove player }

      before do
        matchmaking_match.add player
      end

      it 'removes a player from the queued representation of a match' do
        expect { subject }.to change { matchmaking_match.player_count }.from(1).to(0)
      end
    end

    describe '#full?' do
      let(:n_of_players) { match.match_type.team_count * match.match_type.team_size }
      let(:players) { create_list :player, n_of_players, league:, game: league.game }

      subject { matchmaking_match.full? }

      before do
        players.each do |player|
          matchmaking_match.add player
        end
      end

      context 'with enough players' do
        it 'returns true' do
          expect(subject).to be(true)
        end
      end

      context 'without enough players' do
        let(:n_of_players) { 1 }

        it 'returns false' do
          expect(subject).to be(false)
        end
      end
    end
  end
end
