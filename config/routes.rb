Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'
  devise_for :users
  
  get "broadcasts/:token", to: "broadcasts#show"
  root "home#landing"
  namespace :hooks do
    post 'messages', to: 'messages#create'
  end

  authenticated :user do
    root 'events#index', as: :authenticated_root
    get 'events/expired', to: "events#expired"
    resources :events, only: [:index, :show, :new, :create] do
      resources :messages, only: [] do
        member do
          post "select"
        end
      end
    end
    resources :purchases,     only: [:new]
    resources :claim_coupons, only: [:new, :create]
  end
end
