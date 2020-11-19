Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # add to application view
  get "/auth/:provider", to: "merchants#new", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  root to: 'homepages#index'

  # resources :products
  # resources :merchants
  # resources :order_items, only: [:delete, :update]
  # resources :orders
  # resources :categories
end
