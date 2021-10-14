Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      root "admins#index"
    end

    root "static_pages#home"

    resources :static_pages, only: %i(cart contact blog about home menu)
  end
end
