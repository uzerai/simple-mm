# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchType, type: :model do
  describe '#initialize' do
    subject { create described_class.to_s.underscore.to_sym }

    it 'should not raise an error' do
      expect { subject }.not_to raise_error
    end
  end
end
