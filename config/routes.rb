Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users

  resources :documents, only: [:index, :new, :create]

  root to: 'home#index'
end
