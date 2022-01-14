# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Application functionality metadata endpoints.
  get '/', to: 'application#root', as: 'version-check'
  
  resources :players
  resources :games

  devise_for :users, only: [:confirmation, :recovery], skip_helpers: [:sessions], controllers: { confirmations: 'confirmations' }
  
  post '/login', to: 'users#login', as: 'user-login'
  post '/signup', to: 'users#create', as: 'user-signup'
  get '/autologin', to: 'users#auto_login', as: 'user-auto-login'
end
