# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Application functionality metadata endpoints.
  get '/', to: 'application#root', as: 'version-check'
  
  resources :players
  
  # Using devise gem for user authentication; will maybe use pundit for user authorization later.
  devise_for :users
  post '/login', to: 'users#login', as: 'user-login'
  get '/autologin', to: 'users#auto_login', as: 'user-auto-login'
end
