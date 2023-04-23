# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:headers) { { Accept: 'application/json', 'Content-Type': 'application/json' } }

  describe '#create' do
    subject { post user_signup_url, headers:, params: params.to_json }
    let(:params) { { username:, email:, password:, password_confirmation: password } }
    let(:password) { Faker::Internet.password }
    let(:username) { Faker::Internet.unique.username }
    let(:email) { Faker::Internet.unique.email }
    let(:headers) { { Accept: 'application/json', 'Content-Type': 'application/json' } }

    context 'when unauthenticated' do
      context 'with valid user parameters' do
        it 'should succeed' do
          subject

          expect(response).to have_http_status(201)
          response_body = JSON.parse(response.body)

          expect(response_body['data']['token']).to be_present
          expect(response_body['data']['refresh_token']).to be_present
        end
      end

      context 'with a username clash' do
        let(:existing_user) { create :user }
        let(:username) { existing_user.username }

        it 'should fail detailing all failing validations' do
          subject

          expect(response).to have_http_status(422)

          response_body = JSON.parse(response.body)

          expect(response_body['data']).to be_nil
          expect(response_body['errors']).not_to be_empty
          expect(response_body['errors'].count).to be 1
          expect(response_body['errors'].first['message']).to eq('username has already been taken')
        end
      end

      context 'with an email clash' do
        let(:existing_user) { create :user }
        let(:email) { existing_user.email }

        it 'should fail detailing all failing validation' do
          subject

          expect(response).to have_http_status(422)

          response_body = JSON.parse(response.body)

          expect(response_body['data']).to be_nil
          expect(response_body['errors']).not_to be_empty
          expect(response_body['errors'].count).to be 1
          expect(response_body['errors'].first['message']).to eq('email has already been taken')
        end
      end
    end
  end

  describe '#login' do
    subject { post user_login_url, headers:, params: params.to_json }

    let(:params) { { email:, password:, password_confirmation: password } }
    let(:password) { Faker::Internet.password }
    let(:email) { Faker::Internet.unique.email }

    context 'without an existing user' do
      it 'should fail' do
        subject

        expect(response).to have_http_status(403)
        response_body = JSON.parse(response.body)
        expect(response_body['errors'].first['message']).to eq('Invalid username or password')
      end
    end

    context 'with credentials for an existing user' do
      let(:existing_user) { create :user }
      let(:password) { existing_user.password }
      let(:email) { existing_user.email }

      it 'should succeed' do
        subject

        expect(response).to have_http_status(200)
        response_body = JSON.parse(response.body)
        expect(response_body['data']['token']).to be_present
        expect(response_body['data']['refresh_token']).to be_present
      end
    end
  end
end
