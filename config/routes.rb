Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'homepages#index'
  resources :products
  resources :merchants
  resources :order_items, only: [:delete, :update]
  resources :orders
  resources :categories
end