Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
      resources :orders
      get "order_status/:status", to: "orders#index_by_status", as: :status
    end
    root "static_pages#home"
    get :home, to: "static_pages#home"
    get :menu, to: "static_pages#menu"
    get :about, to: "static_pages#about"
    get :blog, to: "static_pages#blog"
    get :contact, to: "static_pages#contact"
    get :cart, to: "static_pages#cart"
    get :login, to: "sessions#new"
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"

    resources :users, only: %i(new create)
  end
  namespace :admin do
    resources :products, only: %i(index)
  end
end
