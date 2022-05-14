# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end

  describe '#spawn_matchmaking_worker' do
    let(:match) { create :match }
    subject { match.spawn_matchmaking_worker! }

    it 'creates a job in the sidekiq job queue' do
      expect { subject }.to change(::Matchmaking::OrganizeMatchWorker.jobs, :count).from(0).to(1)
    end
  end
end
