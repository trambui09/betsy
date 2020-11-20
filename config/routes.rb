Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # add to application view
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"

  root to: 'homepages#index'

  resources :products
  resources :merchants
  resources :order_items, only: [:delete, :update]
  resources :orders
  resources :categories do
    resources :products, only: [:index]
  end
end
