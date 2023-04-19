# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => "/sidekiq"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Application functionality metadata endpoints.
  get '/', to: 'application#root', as: 'version-check'

  resources :players
  get '/games', to: 'games#index', as: 'all-games'
  get '/games/:game_slug', to: 'games#show', as: 'game'
  get '/leagues/:id', to: 'leagues#show', as: 'league'
  post '/leagues/:id/join', to: 'leagues#join', as: 'join_league'
  get '/matches/:id', to: 'matches#show', as: 'match'

  # Matchmaking related endpoints
  post '/matchmaking/queue', to: 'matchmaking#queue', as: 'join-queue'

  devise_for :users, only: %i[confirmation recovery], skip_helpers: [:sessions],
                     controllers: { confirmations: 'confirmations' }

  post '/login', to: 'users#login', as: 'user-login'
  post '/signup', to: 'users#create', as: 'user-signup'
  get '/autologin', to: 'users#auto_login', as: 'user-auto-login'
end
