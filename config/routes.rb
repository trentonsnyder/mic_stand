Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'
  devise_for :users

  # workaround for devise + turbolinks POST issues on refresh ###
  # https://github.com/plataformatec/devise/issues/4470
  resources :users, only: [:index]
  get 'users/password', to: "users#password"
  ##################

  authenticated :user do
    root 'events#index', as: :authenticated_root
    get 'events/expired', to: "events#expired"
    
    resources :events, only: [:index, :show, :new, :create] do
      member do
        get 'broadcast', to: "events#broadcast"
      end
      resources :messages, only: [] do
        member do
          post "select"
        end
      end
    end

    resources :claim_coupons, only: [:new, :create]
    # for stripe gem
    resources :charges
  end

  ## unauthenticated routes ##

  root "home#landing"
  post "broadcasts/mailer", to: "broadcasts#mailer"
  get "broadcasts/:token", to: "broadcasts#show"
  
  namespace :hooks do
    post 'messages', to: 'messages#create'
  end

end
