Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "orders#index"
      resources :orders do
        member do
          put :approve
          put :reject
        end
      end
      get "order_status/:status", to: "orders#index_by_status", as: :status
      resources :products, except: :delete do
        collection {post :import}
        member do
          delete :purge_images
          delete :purge_thumbnail
        end
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
      resources :orders, only: %i(index show) do
        put :cancel, on: :member
      end
    end
    resources :products, only: :show
  end
end
