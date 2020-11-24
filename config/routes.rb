Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # add to application view
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
  post "/products/:id/orders", to: "order_items#create", as: "add_cart"
  get "/cart", to: "orders#cart", as: "show_cart"
  patch "/orders/:id/cancel", to: "orders#cancel", as: "cancel_order"
  patch "/orders/:id", to: "orders#checkout", as: "paid_order"
  post "/products/:id", to: "products#update_status", as: "update_product_status"

  root to: 'homepages#index'

  resources :categories do
    resources :products, only: [:index]
  end

  resources :merchants do
    resources :orders, only: [:index]
    resources :products, only: [:index, :update_status]
  end

  resources :categories, only: [:index, :show, :new, :create]
  resources :products
  resources :order_items, only: [:destroy, :update, :create]
  resources :orders, only: [:show, :new]
end
