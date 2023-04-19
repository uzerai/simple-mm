# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Matchmaking::FindMatchWorker, typer: :worker do
  before do
    allow(ApplicationVariable).to receive(:get).with('matchmaking_enabled').and_return('true')
  end

  it 'responds to #perform' do
    expect(Matchmaking::FindMatchWorker.new).to respond_to(:perform)
  end

  describe '#perform' do
    let(:league) { create :league }
    let(:player) { create :player, league:, game: league.game }
    let(:matchmaking_queue) do
      Matchmaking::Queue.new(league:)
    end

    subject { Matchmaking::FindMatchWorker.new.perform(league.id, player.id) }

    before do
      Sidekiq::Extensions.enable_delay!
      Sidekiq::Worker.clear_all
    end

    context 'there exists no Matches' do
      it 'creates a match' do
        expect { subject }.to change(Match, :count).from(0).to(1)
      end

      it 'creates a OrganizeMatchWorker' do
        expect { subject }.to change(Matchmaking::OrganizeMatchWorker.jobs, :count).from(0).to(1)
      end
    end

    context 'there are existing Matches' do
      let(:state) { Match::STATE_QUEUED }

      before { create :match, league:, state:, match_type: league.match_type }

      context 'in non-complete states' do
        it 'should not create a match' do
          expect { subject }.not_to change(Match, :count)
        end
      end

      context 'in completed states' do
        let(:state) { Match::STATE_COMPLETED }
        it 'should create a match' do
          expect { subject }.to change(Match, :count).from(1).to(2)
        end
      end
    end

    context 'the user has already found a match' do
      let(:matchmaking_match) do
        Matchmaking::Match.new(match: create(:match, league:, match_type: league.match_type))
      end

      before do
        matchmaking_match.add player
      end

      it 'does not add the player to queue' do
        expect { subject }.not_to change(matchmaking_queue.count(no_cache: true))
      end
    end

    context 'the user is already playing in a match' do
      let(:match) { create :match, league:, match_type: league.match_type }

      before do
        create :match_player, player:, match:
      end

      it 'does not add the player to queue' do
        expect { subject }.not_to change(matchmaking_queue.count(no_cache: true))
      end
    end
  end
end
