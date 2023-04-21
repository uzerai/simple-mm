# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  describe '#root' do
    subject { get version_check_url, headers: }

    # Technically tests the BaseController#ensure_content_type
    context 'with accept-header set' do
      let(:headers) { { Accept: 'application/json' } }

      it 'should return the full response format' do
        subject

        expect(response.code).to eq('200')
        expect(response.body).to include('0.0.1')
      end
    end

    context 'without accept header set' do
      let(:headers) { {} }

      it 'should cause an error' do
        subject

        expect(response.code).not_to eq('200')
      end
    end
  end
end
