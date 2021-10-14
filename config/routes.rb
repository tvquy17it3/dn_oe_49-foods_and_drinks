Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
      resources :orders do
        member do
          put :approve
          put :reject
        end
      end
      get "order_status/:status", to: "orders#index_by_status", as: :status
      resources :products, except: %i(update delete) do
        collection {post :import}
      end
    end

    root "static_pages#home"
    get :home, to: "static_pages#home"
    get :menu, to: "products#index"
    get :about, to: "static_pages#about"
    get :blog, to: "static_pages#blog"
    get :contact, to: "static_pages#contact"
    get :cart, to: "static_pages#cart"
    get :login, to: "sessions#new"
    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
    get :order, to: "orders#new"

    resources :users, only: %i(new create) do
      resources :orders, only: %i(index show)
    end
    resources :products, only: :show
  end
end
