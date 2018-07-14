Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'
  devise_for :users

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

    get 'insights',                    to: 'insights#index'
    get 'insights/all_messages_chart', to: 'insights#all_messages_chart'
    get 'insights/keywords_chart', to: 'insights#keywords_chart'

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
