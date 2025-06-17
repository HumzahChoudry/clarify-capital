Rails.application.routes.draw do
  resources :clients
  resources :lenders

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "clients#index" 
end