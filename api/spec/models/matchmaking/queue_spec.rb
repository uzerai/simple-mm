# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Matchmaking::Queue, type: :model do
  # No factory for matchmaking queue, as it serves only as a API client
  # to the redis representation of queue state.
  let(:matchmaking_queue) { build :'matchmaking/queue', league: }
  let(:league) { create :league }
  let(:player) { create :player, league:, game: league.game }
  describe 'Queue manipulation' do
    describe '#add' do
      subject { matchmaking_queue.add player }

      it 'adds the user to a representative queue' do
        expect(subject).to be(true)
        expect(matchmaking_queue.queue_count).to eq(1)
      end
    end

    describe '#queue_count' do
      let(:random_n_players) { rand(1..50) }
      let(:players) { create_list :player, random_n_players, league:, game: league.game }
      subject { matchmaking_queue.queue_count }

      before do
        players.each do |q_player|
          matchmaking_queue.add q_player
        end
      end

      it 'returns the number of players' do
        expect(subject).to be(random_n_players)
      end

      it 'has a cache lifetime for the count' do
        expect(subject).to be(random_n_players)
        matchmaking_queue.remove players.sample
        # The value hasn't changed; subject is not used due to it being memoized per test.
        expect(matchmaking_queue.queue_count).to be(random_n_players)
        Kernel.sleep(1)
        # We removed a player earlier
        expect(matchmaking_queue.queue_count).to eq(random_n_players - 1)
      end
    end

    describe '#reserve_player_from_queue' do
      subject { matchmaking_queue.reserve_player }

      before do
        matchmaking_queue.add player
      end

      it 'returns a player from the queue' do
        expect(subject).to eq([
                                matchmaking_queue.player_value(player)
                              ])
      end

      it 'removes the player from the queue' do
        subject
        expect(matchmaking_queue.queue_count).to eq(0)
      end
    end
  end
end
