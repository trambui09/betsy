Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # add to application view
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
  post "/products/:id/orders", to: "order_items#create", as: "add_cart"
  get "/cart", to: "orders#cart", as: "show_cart"
  # get cart_id from session make custom route
  # show for confirmation page

  root to: 'homepages#index'

  resources :products
  resources :merchants
  resources :order_items, only: [:create, :update, :destroy]
  resources :orders, except: [:index]
  resources :categories
  resources :categories do
    resources :products, only: [:index]
  end
end
