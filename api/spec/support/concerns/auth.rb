# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'auth' do
  context 'with a valid user' do
    let(:user) { FactoryBot.create(:user) }
  end
end
