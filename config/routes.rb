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
  get '/signup', to: 'users#new'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
