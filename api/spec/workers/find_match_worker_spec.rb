# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe Matchmaking::FindMatchWorker, typer: :worker do
  it 'responds to #perform' do
    expect(Matchmaking::FindMatchWorker.new).to respond_to(:perform)
  end

  describe '#perform' do
    let(:league) { create :league }
    let(:player) { create :player, league:, game: league.game }

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
      before { create :match, league:, match_type: league.match_type }

      it 'should not create a match' do
        expect { subject }.not_to change(Match, :count)
      end
    end
  end
end
