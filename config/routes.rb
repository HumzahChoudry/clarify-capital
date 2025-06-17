Rails.application.routes.draw do
  resources :clients do
    member do
      post :create_best_loan
    end
  end
  resources :lenders
  resources :loans, only: [:new, :create, :edit, :update]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "clients#index" 
end