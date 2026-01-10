# Rails.application.routes.draw do
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Defines the root path route ("/")
#   # root "posts#index"
# end
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # === Authentication ===
      post "login", to: "sessions#create"
      post "refresh", to: "sessions#refresh"
      delete "logout", to: "sessions#destroy"

      # === Categories ===
      resources :categories, only: [:index, :show] do
        # GET /api/v1/categories/:category_id/announcements
        resources :announcements, only: [:index]
      end

      # === Announcements ===
      resources :announcements, only: [:index, :show, :create, :update, :destroy] do
        member do
          patch :increment_views
          patch :reserve
          patch :mark_as_sold
        end

        collection do
          get :search
          get :popular
          get :recent
        end
      end

      # === Sellers ===
      # Current seller endpoints
      get "sellers/me", to: "sellers#me"
      patch "sellers/me", to: "sellers#update"
      delete "sellers/me", to: "sellers#destroy"

      resources :sellers, only: [:create, :show] do
        # GET /api/v1/sellers/:seller_id/announcements
        get :announcements, on: :member
      end
    end
  end

  # Health check
  get "health", to: proc { [200, {}, ["OK"]] }
end