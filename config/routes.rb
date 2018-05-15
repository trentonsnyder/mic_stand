Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'events#index', as: :authenticated_root
  end

  root "home#landing"
end
