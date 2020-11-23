Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # add to application view
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
  post "/products/:id/orders", to: "order_items#create", as: "add_cart"
  get "/cart", to: "orders#cart", as: "show_cart"
  post "/orders/:id", to: "orders#checkout", as: "paid_order"
  patch "/orders/:id", to: "orders#cancel", as: "cancel_order"

  # get "merchants/:id/products", to: "products#merchant_product_index", as: "merchant_products"

  root to: 'homepages#index'

  resources :categories do
    resources :products, only: [:index]
  end

  resources :merchants do
    resources :products, only: [:index]
    resources :orders, only: [:index]
  end

  resources :categories
  resources :products
  resources :order_items, only: [:destroy, :update, :create]
  resources :orders, only: [:show, :new]
end
