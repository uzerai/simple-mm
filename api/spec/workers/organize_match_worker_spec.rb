# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

# Required for matching against the errors defined in matchmaking
require 'matchmaking'

Sidekiq::Testing.fake!

RSpec.describe Matchmaking::OrganizeMatchWorker, typer: :worker do
  let(:match) { create :match }

  before do
    allow(ApplicationVariable).to receive(:get).with("matchmaking_enabled").and_return("true")
  end

  it 'responds to #perform' do
    expect(Matchmaking::OrganizeMatchWorker.new).to respond_to(:perform)
  end

  describe '#perform' do
    subject { Matchmaking::OrganizeMatchWorker.new.perform match.id }

    context 'insufficient players in queue' do
      it 'raises a NoPlayersError' do
        expect { subject }.to raise_exception Matchmaking::Errors::NoPlayersError
      end
    end

    context 'sufficient players in queue' do
      let(:players) { create_list :player, (match.match_type.team_size * match.match_type.team_count), game: match.game, league: match.league }
      let(:mm_queue) { Matchmaking::Queue.new(league: match.league) }
      let(:mm_match) { Matchmaking::Match.new(match:) }

      before do
        players.each { |player| mm_queue.add player }

        # To avoid waiting the 30s ready-check
        allow_any_instance_of(Matchmaking::Match).to receive(:ready?).and_return(true)
      end

      it 'removes players from queue' do
        expect { subject }.to change { mm_queue.count(no_cache: true) }.from(players.count).to(0)
      end

      it 'creates a match representation in redis' do
        expect { subject }.to change { mm_match.player_count }.from(0).to(players.count)
      end

      context 'reserving a player fails' do
        before do
          allow_any_instance_of(Matchmaking::Queue).to receive(:reserve_player).and_return(nil)
        end

        it 'raises a MatchNotFinalizedError' do
          expect { subject }.to raise_error Matchmaking::Errors::MatchNotFinalizedError
        end
      end

      context 'time runs out' do
        before do
          stub_const 'Matchmaking::OrganizeMatchWorker::MATCHMAKING_READY_CHECK_WAIT_TIME', 1
          allow_any_instance_of(Matchmaking::Match).to receive(:ready?).and_return(false)
        end

        it 'raises a MatchNotFinalizedError and cancels the match' do
          expect { subject }.to change { match.reload.state }.from('queued').to('cancelled')
                                                             .and raise_error(Matchmaking::Errors::MatchNotFinalizedError)
        end
      end
    end
  end
end
