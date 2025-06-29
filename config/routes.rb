# frozen_string_literal: true

Rails.application.routes.draw do
  root 'static_pages#home'
  resources :static_pages, path: '', only: [] do
    collection do
      get :home
      get :about
    end
  end
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
