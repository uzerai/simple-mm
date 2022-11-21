# frozen_string_literal: true

require 'rails_helper'
require 'matchmaking_helper'

RSpec.describe Matchmaking::Player, type: :model do
  let(:league) { create :league }
  let(:player) { create :player, league:, game: league.game }
  let(:match) { create :match, league:, game: league.game, match_type: league.match_type }
  let(:matchmaking_player) { Matchmaking::Player.new(player:) }

  describe 'Matchmaking::Player.details' do
    let(:formatted_player_value) { Matchmaking::Player.new(player:).value }

    subject { Matchmaking::Player.details(formatted_player_value) }

    it 'destructures the player_value correctly' do
      expect(subject[:id]).to eq(player.id)
      expect(subject[:username]).to eq(player.username)
    end
  end

  describe '#remove_from_matches!' do
    subject { matchmaking_player.remove_from_matches! }

    context 'player is in match' do
      let(:matchmaking_match) { Matchmaking::Match.new(match:) }

      before do
        matchmaking_match.add player
      end

      it 'removes player from match' do
        expect { subject }.to change { matchmaking_match.player_count }.from(1).to(0)
      end
    end
  end

  describe '#matches' do
    subject { matchmaking_player.matches }

    context 'player is in match' do
      let(:matchmaking_match) { Matchmaking::Match.new(match:) }

      before do
        matchmaking_match.add player
      end

      it 'returns an array containing number of matches items' do
        expect(subject.count).to eq(1)
      end
    end
  end
end
