Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'events#index', as: :authenticated_root

    get 'events/expired',     to: "events#expired"
    resources :events,        only: [:index, :show, :new, :create]
    resources :purchases,     only: [:new]
    resources :claim_coupons, only: [:new, :create]
  end
  
  get "broadcasts/:token", to: "broadcasts#show"
  root "home#landing"

  namespace :hooks do
    post 'messages', to: 'messages#create'
  end
end
