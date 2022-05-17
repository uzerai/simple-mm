# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matchmaking::Match, type: :model do
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

  describe '#ready_up' do
    subject { matchmaking_match.ready_up player }

    before do
      matchmaking_match.add player
    end

    it 'adds the player to readied players' do
      expect { subject }.to change { matchmaking_match.ready_players.count }.from(0).to(1)
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

  describe '#cancel!' do
    subject { matchmaking_match.cancel! }

    before do
      matchmaking_match.add player
      matchmaking_match.ready_up player
    end

    it 'removes players from the ready check' do
      expect { subject }.to change{ matchmaking_match.ready_players.count }.from(1).to(0)
    end

    it 'removes players from the match representation' do
      expect { subject }.to change { matchmaking_match.player_count }.from(1).to(0)
    end

    context 'with one unready player' do
      let(:player_two) { create :player, league:, game: league.game }
      let(:matchmaking_queue) { Matchmaking::Queue.new(league: match.league) }

      before do
        matchmaking_match.add player_two
      end
      
      it 'adds only the ready players back to queue' do
        expect { subject }.to change { matchmaking_queue.count(no_cache: true) }.from(0).to(1)
      end
    end
  end

  describe '#ready?' do
    let(:n_of_players) { match.match_type.team_count * match.match_type.team_size }
    let(:players) { create_list :player, n_of_players, league:, game: league.game }

    subject { matchmaking_match.ready? }

    before do
      players.each do |player|
        matchmaking_match.add player
      end
    end

    context 'with no players readied' do
      it 'returns false' do
        expect(subject).to be(false)
      end
    end

    context 'with all players readied' do
      before do
        players.each do |player|
          matchmaking_match.ready_up player
        end
      end

      it 'returns true' do
        expect(subject).to be(true)
      end

      it 'retains both sets' do
        subject

        expect(matchmaking_match.player_count).to eq(n_of_players)
        expect(matchmaking_match.ready_players.count).to eq(n_of_players)
      end
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
