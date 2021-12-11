# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Application functionality metadata endpoints.
  get '/', to: 'application#root', as: 'version-check'
   
  resources :players
end
